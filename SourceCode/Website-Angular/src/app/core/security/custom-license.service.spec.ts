import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting, HttpTestingController } from '@angular/common/http/testing';
import { provideRouter } from '@angular/router';
import { JwtHelperService, JWT_OPTIONS } from '@auth0/angular-jwt';
import { LicenseValidatorService } from '@mlglobtech/license-validator-docnet';
import { CustomLicenseInitializerService, CustomLicenseValidatorService } from './custom-license.service';

describe('License activation integration', () => {
  let http: HttpTestingController;
  let service: CustomLicenseInitializerService;
  let originalUrl: string;
  let profileKey: string;
  let previousProfile: string | null;

  beforeEach(() => {
    originalUrl = location.href;
    TestBed.configureTestingModule({ providers: [
      provideHttpClient(), provideHttpClientTesting(), provideRouter([]),
      { provide: JWT_OPTIONS, useValue: {} }, JwtHelperService,
      { provide: LicenseValidatorService, useClass: CustomLicenseValidatorService },
      CustomLicenseInitializerService,
    ] });
    http = TestBed.inject(HttpTestingController);
    service = TestBed.inject(CustomLicenseInitializerService);
    profileKey = TestBed.inject(LicenseValidatorService).keyValues.COMPANY_PROFILE;
    previousProfile = sessionStorage.getItem(profileKey);
  });

  afterEach(() => {
    http.verify();
    history.replaceState(null, '', originalUrl);
    if (previousProfile === null) sessionStorage.removeItem(profileKey);
    else sessionStorage.setItem(profileKey, previousProfile);
  });

  it('processes activation callbacks through the vendor initializer', async () => {
    // Invalid test data is intercepted locally; no request reaches the license service or API.
    history.replaceState(null, '', '?purchase_code=invalid-test-data&generate_key=invalid-test-data');
    const result = service.initialize();
    const request = http.expectOne('companyprofile/activate_license');
    expect(request.request.method).toBe('POST');
    request.flush(true);
    expect(await result).toBe('tokenadded');
  });

  it('does not report activation success when persistence fails', async () => {
    history.replaceState(null, '', '?purchase_code=invalid-test-data&generate_key=invalid-test-data');
    const result = service.initialize();
    http.expectOne('companyprofile/activate_license').flush(false);
    expect(await result).toBe('notupdated');
  });

  it('keeps vendor verification and banner behavior for an invalid profile', async () => {
    history.replaceState(null, '', location.pathname);
    const validator = TestBed.inject(LicenseValidatorService);
    const verify = spyOn(validator, 'verifyLicense').and.returnValue(false);
    const banner = spyOn(validator, 'showBanner');
    const result = service.initialize();
    http.expectOne('companyprofile').flush({ licenseKey: '', purchaseCode: '' });
    await result;
    expect(verify).toHaveBeenCalledWith('', '');
    expect(banner).toHaveBeenCalled();
  });

  it('propagates a profile lookup failure instead of silently succeeding', async () => {
    history.replaceState(null, '', location.pathname);
    const result = service.initialize();
    const assertion = expectAsync(result).toBeRejected();
    http.expectOne('companyprofile').flush({}, { status: 503, statusText: 'Unavailable' });
    await assertion;
  });
});
