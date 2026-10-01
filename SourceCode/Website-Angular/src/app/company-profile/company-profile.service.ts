import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError, Observable } from 'rxjs';
import { CommonError } from '@core/error-handler/common-error';
import { CommonHttpErrorService } from '@core/error-handler/common-http-error.service';
import { CompanyProfile } from './company-profile';

@Injectable({ providedIn: 'root' })
export class CompanyProfileService {
  private commonHttpErrorService = inject(CommonHttpErrorService);
  private httpClient = inject(HttpClient);


  getCompanyProfile(): Observable<CompanyProfile> {
    return this.httpClient.get<CompanyProfile>('companyprofile');
  }

  updateCompanyProfile(companyProfile: CompanyProfile, logoFile?: File, bannerFile?: File, logoIconFile?: File): Observable<CompanyProfile> {
    const url = companyProfile.id ? `companyprofile/${companyProfile.id}` : `companyprofile`;
    const formData = new FormData();
    if (companyProfile.id) {
      formData.append('id', companyProfile.id);
    }
    formData.append('name', companyProfile.name ?? '');
    if (logoFile) {
      formData.append('logoFile', logoFile);
    }
    if (bannerFile) {
      formData.append('bannerFile', bannerFile);
    }
    if (logoIconFile) {
      formData.append('logoIconFile', logoIconFile);
    }
    return this.httpClient.post<CompanyProfile>(url, formData);
  }
}
