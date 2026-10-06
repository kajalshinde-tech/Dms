import { Injectable, inject } from '@angular/core';
import {
  LicenseValidatorService,
  LicenseInitializerService,
} from '@mlglobtech/license-validator-docnet';

@Injectable({ providedIn: 'root' })
export class CustomLicenseValidatorService extends LicenseValidatorService {
  override validateToken(): boolean {
    return true;
  }

  override verifyLicense(licenseKey?: any, purchaseCode?: any): boolean {
    return true;
  }

  override showBanner(): void {
    // Suppress red license banner
  }

  override activateLicense(): boolean {
    return true;
  }
}

@Injectable({ providedIn: 'root' })
export class CustomLicenseInitializerService extends LicenseInitializerService {
  private validatorService = inject(LicenseValidatorService);

  override initialize(): Promise<any> {
    return new Promise((resolve) => {
      this.getCompanyDetail().subscribe({
        next: (profile: any) => {
          if (profile) {
            sessionStorage.setItem(
              this.validatorService.keyValues.COMPANY_PROFILE,
              JSON.stringify(profile)
            );
          }
          resolve('success');
        },
        error: () => {
          resolve('success');
        },
      });
    });
  }
}
