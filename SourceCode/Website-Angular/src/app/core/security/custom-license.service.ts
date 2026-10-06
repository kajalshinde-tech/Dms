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

  override initialize(): Promise<any> {
    return new Promise((resolve) => {
      this.getCompanyDetail().subscribe({
        next: (profile: any) => {
          if (profile) {
            const sanitized = { ...profile };
            if (sanitized.logoUrl) sanitized.logoUrl = this.normalizeUrl(sanitized.logoUrl);
            if (sanitized.logoIconUrl) sanitized.logoIconUrl = this.normalizeUrl(sanitized.logoIconUrl);
            if (sanitized.bannerUrl) sanitized.bannerUrl = this.normalizeUrl(sanitized.bannerUrl);

            sessionStorage.setItem(
              this.validatorService.keyValues.COMPANY_PROFILE,
              JSON.stringify(sanitized)
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
