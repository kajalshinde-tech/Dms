import { Injectable, inject } from '@angular/core';
import {
  LicenseValidatorService,
  LicenseInitializerService,
} from '@mlglobtech/license-validator-docnet';
import { normalizeImageUrl } from './security.service';

@Injectable({ providedIn: 'root' })
export class CustomLicenseValidatorService extends LicenseValidatorService {
  // Keep the vendor's token, domain, and license verification behavior.
}

@Injectable({ providedIn: 'root' })
export class CustomLicenseInitializerService extends LicenseInitializerService {
  private validatorService = inject(LicenseValidatorService);

  private normalizeUrl(url?: string | null): string | undefined {
    return normalizeImageUrl(url);
  }

  override async initialize(): Promise<any> {
    // Process the vendor activation callback before normalizing cached image URLs.
    const result = await super.initialize();
    const key = this.validatorService.keyValues.COMPANY_PROFILE;
    const cached = sessionStorage.getItem(key);
    if (result === 'success' && cached) {
      const profile = JSON.parse(cached);
      for (const field of ['logoUrl', 'logoIconUrl', 'bannerUrl']) {
        if (profile[field]) profile[field] = this.normalizeUrl(profile[field]);
      }
      sessionStorage.setItem(key, JSON.stringify(profile));
    }
    return result;
  }
}
