import { Injectable } from '@angular/core';
import { Observable, BehaviorSubject, of } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { tap, catchError } from 'rxjs/operators';
import { UserAuth } from '../domain-classes/user-auth';
import { CommonHttpErrorService } from '../error-handler/common-http-error.service';
import { ClonerService } from '../services/clone.service';
import { CommonError } from '../error-handler/common-error';
import { User } from '@core/domain-classes/user';
import { Router } from '@angular/router';
import { CompanyProfile } from '../../company-profile/company-profile';
import { LicenseValidatorService } from '@mlglobtech/license-validator-docnet';

@Injectable({ providedIn: 'root' })
export class SecurityService {
  securityObject: UserAuth = new UserAuth();
  private securityObject$: BehaviorSubject<UserAuth | null> =
    new BehaviorSubject<UserAuth | null>(null);

  private companyProfile$: BehaviorSubject<CompanyProfile | null> =
    new BehaviorSubject<CompanyProfile | null>(null);
  public get SecurityObject(): Observable<UserAuth | null> {
    return this.securityObject$.asObservable();
  }
  constructor(
    private http: HttpClient,
    private clonerService: ClonerService,
    private commonHttpErrorService: CommonHttpErrorService,
    private router: Router,
    private licenseValidatorService: LicenseValidatorService
  ) { }
  isUserAuthenticate(): boolean {
    if (this.securityObject.userName && this.securityObject.bearerToken) {
      return true;
    } else {
      return this.parseSecurityObj();
    }
  }
  private normalizeUrl(url?: string | null): string | undefined {
    if (!url) return undefined;
    if (url.startsWith('http://') || url.startsWith('https://')) {
      const idx = url.indexOf('/images/');
      if (idx !== -1) {
        return url.substring(idx);
      }
    }
    return url;
  }

  private sanitizeCompanyProfile(profile: CompanyProfile): CompanyProfile {
    if (!profile) return profile;
    const cloned = { ...profile };
    if (cloned.logoUrl) cloned.logoUrl = this.normalizeUrl(cloned.logoUrl);
    if (cloned.logoIconUrl) cloned.logoIconUrl = this.normalizeUrl(cloned.logoIconUrl);
    if (cloned.bannerUrl) cloned.bannerUrl = this.normalizeUrl(cloned.bannerUrl);
    return cloned;
  }

  setCompany(companyProfile?: CompanyProfile) {
    if (companyProfile) {
      const sanitized = this.sanitizeCompanyProfile(companyProfile);
      sessionStorage.setItem(
        this.licenseValidatorService.keyValues.COMPANY_PROFILE,
        JSON.stringify(sanitized)
      );
      this.companyProfile$.next(JSON.parse(JSON.stringify(sanitized)));
    } else {
      const companyProfileJson = sessionStorage.getItem(
        this.licenseValidatorService.keyValues.COMPANY_PROFILE
      );
      if (
        companyProfileJson &&
        companyProfileJson !== 'null' &&
        companyProfileJson !== 'undefined'
      ) {
        const parsed = JSON.parse(companyProfileJson);
        this.companyProfile$.next(this.sanitizeCompanyProfile(parsed));
      }
    }
  }

  public get companyProfile(): Observable<CompanyProfile | null> {
    return this.companyProfile$.asObservable();
  }

  login(entity: User): Observable<UserAuth> {
    // Initialize security object
    this.resetSecurityObject();
    return this.http
      .post<UserAuth>('user/login', entity)
      .pipe(
        tap((resp) => {
          this.securityObject = this.clonerService.deepClone<UserAuth>(resp);
          this.licenseValidatorService.setTokenValue(this.securityObject);
          this.securityObject$.next(resp);
        })
      );
  }
  refreshToken(): Observable<UserAuth | CommonError> {
    return this.http
      .get<UserAuth>('user/refresh_token')
      .pipe(
        tap((resp) => {
          this.securityObject = this.clonerService.deepClone<UserAuth>(resp);
          this.licenseValidatorService.setTokenValue(this.securityObject);
          this.securityObject$.next(resp);
        })
      )
      .pipe(catchError(this.commonHttpErrorService.handleError));
  }

  public parseSecurityObj(): boolean {
    const secuObj = this.licenseValidatorService.getAuthObject();
    if (!secuObj) {
      return false;
    }
    this.securityObject = this.clonerService.deepClone<UserAuth>(secuObj);
    if (this.securityObject.userName && this.securityObject.bearerToken) {
      this.securityObject$.next(this.securityObject);
      return true;
    }
    return false;
  }

  logout(): void {
    this.resetSecurityObject();
  }

  resetSecurityObject(): void {
    this.securityObject.userName = '';
    this.securityObject.bearerToken = '';
    this.securityObject.isAuthenticated = false;
    this.securityObject.firstName = '';
    this.securityObject.lastName = '';
    this.securityObject.claims = [];
    this.licenseValidatorService.removeToken();
    sessionStorage.clear();
    this.securityObject$.next(null);
    this.router.navigate(['/login']);
  }

  // This method can be called a couple of different ways
  // *hasClaim="'claimType'"  // Assumes claimValue is true
  // *hasClaim="'claimType:value'"  // Compares claimValue to value
  // *hasClaim="['claimType1','claimType2:value','claimType3']"
  // tslint:disable-next-line: typedef
  hasClaim(claimType: any, claimValue?: any): boolean {
    let ret = false;
    // See if an array of values was passed in.
    if (typeof claimType === 'string') {
      ret = this.isClaimValid(claimType, claimValue);
    } else {
      const claims: string[] = claimType;
      if (claims.length === 0) {
        return true;
      }
      if (claims) {
        // tslint:disable-next-line: prefer-for-of
        for (let index = 0; index < claims.length; index++) {
          ret = this.isClaimValid(claims[index]);
          // If one is successful, then let them in
          if (ret) {
            break;
          }
        }
      }
    }
    return ret;
  }

  private isClaimValid(claimType: string, claimValue?: string): boolean {
    let ret = false;
    let auth: UserAuth | null = null;
    // Retrieve security object
    auth = this.securityObject;
    if (auth) {
      // See if the claim type has a value
      // *hasClaim="'claimType:value'"
      if (claimType.indexOf(':') >= 0) {
        const words: string[] = claimType.split(':');
        claimType = words[0].toLowerCase();
        claimValue = words[1];
      } else {
        claimType = claimType.toLowerCase();
        // Either get the claim value, or assume 'true'
        claimValue = claimValue ? claimValue : 'true';
      }
      // Attempt to find the claim
      ret =
        auth.claims.find(
          (c) =>
            c.claimType?.toLowerCase() == claimType?.toLowerCase() &&
            c.claimValue == claimValue
        ) != null;
    }

    return ret;
  }

  getUserDetail(): UserAuth | null {
    const userObj = this.licenseValidatorService.getAuthObject();
    if (!userObj) {
      return null;
    }
    return userObj as UserAuth;
  }

  setUserDetail(user: UserAuth) {
    this.securityObject = this.clonerService.deepClone<UserAuth>(user);
    this.licenseValidatorService.setTokenValue(this.securityObject);
  }

  getQueryParam(param: string): string | null {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
  }

  getCompanyProfile(): Observable<CompanyProfile> {
    const url = `companyprofile`;
    return this.http.get<CompanyProfile>(url);
  }
  updateCompanyProfile(
    licenseKey: string,
    purchaseCode: string
  ): Observable<boolean | CommonError> {
    const url = `companyprofile/activate_license`;
    return this.http
      .post<boolean>(url, {
        purchaseCode: purchaseCode,
        licenseKey: licenseKey,
      })
      .pipe(catchError(this.commonHttpErrorService.handleError));
  }
}
