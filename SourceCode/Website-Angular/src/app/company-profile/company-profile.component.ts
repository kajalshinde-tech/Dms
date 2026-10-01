import {
  Component,
  ElementRef,
  inject,
  OnInit,
  ViewChild,
} from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { CompanyProfileService } from './company-profile.service';
import { CompanyProfile } from './company-profile';
import { RouterModule } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';

import { ToastrService } from '@core/services/toastr-service';
import { TranslationService } from '@core/services/translation.service';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatTooltipModule } from '@angular/material/tooltip';
import { SecurityService } from '../core/security/security.service';
import { NgClass } from '@angular/common';
import { ThemeService, THEME_PALETTES, THEME_FONTS, SIDEBAR_ACTIVE_STYLES, SidebarActiveStyle } from '@core/services/theme.service';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';

@Component({
  selector: 'app-company-profile',
  standalone: true,
  imports: [
    FormsModule,
    TranslateModule,
    RouterModule,
    MatButtonModule,
    ReactiveFormsModule,
    MatIconModule,
    MatCardModule,
    NgClass,
    MatSelectModule,
    MatFormFieldModule,
    MatTooltipModule
  ],
  templateUrl: './company-profile.component.html',
  styleUrls: ['./company-profile.component.scss']
})
export class CompanyProfileComponent implements OnInit {
  @ViewChild('logoUpload', { static: false }) logoUploadInput!: ElementRef;
  @ViewChild('logoIconUpload', { static: false }) logoIconUploadInput!: ElementRef;
  @ViewChild('bannerUpload', { static: false }) bannerUploadInput!: ElementRef;
  companyProfileForm: FormGroup;

  private companyProfileService = inject(CompanyProfileService);
  private toastrService = inject(ToastrService);
  private translationService = inject(TranslationService);
  private securityService = inject(SecurityService);
  public themeService = inject(ThemeService);

  themePalettes = THEME_PALETTES;
  themeFonts = THEME_FONTS;
  sidebarActiveStyles = SIDEBAR_ACTIVE_STYLES;

  companyId: string = '';
  logoUrl: string | ArrayBuffer | null = null;
  logoIconUrl: string | ArrayBuffer | null = null;
  bannerUrl: string | ArrayBuffer | null = null;

  logoFile?: File;
  logoIconFile?: File;
  bannerFile?: File;

  constructor(private fb: FormBuilder) { }

  setFontFamily(fontFamily: string): void {
    this.themeService.setFontFamily(fontFamily);
    this.toastrService.success('Font style updated successfully');
  }

  setSidebarActiveStyle(style: SidebarActiveStyle): void {
    this.themeService.setSidebarActiveStyle(style);
    this.toastrService.success('Sidebar active style updated');
  }

  getSelectedFontName(): string {
    const current = this.themeService.currentTheme().fontFamily;
    const match = this.themeFonts.find(f => f.family === current);
    return match ? match.name : 'Plus Jakarta Sans';
  }

  getSelectedFontPreview(): string {
    const current = this.themeService.currentTheme().fontFamily;
    const match = this.themeFonts.find(f => f.family === current);
    return match ? match.preview : 'Refined SaaS';
  }

  setPrimaryColor(color: string, showToast = true): void {
    this.themeService.setPrimaryColor(color);
    if (showToast) {
      this.toastrService.success('Primary theme color updated');
    }
  }

  setSidebarBg(color: string, showToast = true): void {
    this.themeService.setSidebarBg(color);
    if (showToast) {
      this.toastrService.success('Sidebar color updated');
    }
  }

  setTopbarBg(color: string, showToast = true): void {
    this.themeService.setTopbarBg(color);
    if (showToast) {
      this.toastrService.success('Topbar color updated');
    }
  }

  onCustomPrimaryChange(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input?.value) {
      this.setPrimaryColor(input.value, false);
    }
  }

  onCustomSidebarChange(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input?.value) {
      this.setSidebarBg(input.value, false);
    }
  }

  onCustomTopbarChange(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input?.value) {
      this.setTopbarBg(input.value, false);
    }
  }

  isPresetColor(list: { name: string; color: string }[], color: string): boolean {
    return list.some(item => item.color.toLowerCase() === color?.toLowerCase());
  }

  onResetTheme(): void {
    this.themeService.resetTheme();
    this.toastrService.success('Theme reset to defaults');
  }

  ngOnInit(): void {
    this.createFormGroup();
    this.getCompanyProfile();
  }

  createFormGroup() {
    this.companyProfileForm = this.fb.group({
      companyTitle: ['', [Validators.required, Validators.maxLength(100)]],
      logo: [this.logoUrl],
      logoIcon: [this.logoIconUrl],
      banner: [this.bannerUrl]
    });
  }

  triggerLogoUpload(fileInput: HTMLInputElement) {
    fileInput.click();
  }

  triggerLogoIconUpload(fileInput: HTMLInputElement) {
    fileInput.click();
  }

  triggerBannerUpload(fileInput: HTMLInputElement) {
    fileInput.click();
  }

  onLogoUpload(event: any) {
    const file = event.target?.files?.[0];
    if (file) {
      this.logoFile = file;
      const reader = new FileReader();
      reader.onload = (e) => {
        this.companyProfileForm.patchValue({ logo: e.target?.result });
        this.logoUrl = e.target?.result ?? '';
      };
      reader.readAsDataURL(file);
    }
  }

  onLogoIconUpload(event: Event): void {
    const input = event.target as HTMLInputElement;
    const file = input?.files?.[0];
    if (file) {
      this.logoIconFile = file;
      const reader = new FileReader();
      reader.onload = (e) => {
        this.companyProfileForm.patchValue({ logoIcon: e.target?.result });
        this.logoIconUrl = e.target?.result ?? '';
      };
      reader.readAsDataURL(file);
    }
  }

  onBannerUpload(event: any) {
    const file = event.target?.files?.[0];
    if (file) {
      this.bannerFile = file;
      const reader = new FileReader();
      reader.onload = (e) => {
        this.companyProfileForm.patchValue({ banner: e.target?.result });
        this.bannerUrl = e.target?.result ?? '';
      };
      reader.readAsDataURL(file);
    }
  }

  onSave() {
    if (this.companyProfileForm.invalid) {
      this.companyProfileForm.markAllAsTouched();
      return;
    }

    const companyProfile: CompanyProfile = {
      id: this.companyId,
      name: this.companyProfileForm.get('companyTitle')?.value
    };

    const logoFile = this.logoFile || (this.logoUploadInput?.nativeElement as HTMLInputElement)?.files?.item(0) || undefined;
    const bannerFile = this.bannerFile || (this.bannerUploadInput?.nativeElement as HTMLInputElement)?.files?.item(0) || undefined;
    const logoIconFile = this.logoIconFile || (this.logoIconUploadInput?.nativeElement as HTMLInputElement)?.files?.item(0) || undefined;

    this.companyProfileService
      .updateCompanyProfile(companyProfile, logoFile, bannerFile, logoIconFile)
      .subscribe({
        next: (c: CompanyProfile) => {
          this.securityService.setCompany(c);
          this.logoFile = undefined;
          this.logoIconFile = undefined;
          this.bannerFile = undefined;
          if (c.logoUrl) {
            this.logoUrl = c.logoUrl;
          }
          if (c.logoIconUrl) {
            this.logoIconUrl = c.logoIconUrl;
          }
          if (c.bannerUrl) {
            this.bannerUrl = c.bannerUrl;
          }
          this.toastrService.success(
            this.translationService.getValue(
              'COMPANY_PROFILE_UPDATED_SUCCESSFULLY'
            )
          );
        },
        error: () => {
          this.toastrService.error(
            this.translationService.getValue('FAILED_TO_SAVE_COMPANY_PROFILE')
          );
        },
      });
  }

  getCompanyProfile(): void {
    // 1. Fetch live data from backend API
    this.securityService.getCompanyProfile().subscribe({
      next: (c: CompanyProfile) => {
        if (c) {
          this.securityService.setCompany(c);
          this.populateCompanyProfile(c);
        }
      },
      error: () => {
        // 2. Fallback to cached companyProfile in securityService
        this.securityService.companyProfile.subscribe((c) => {
          if (c) {
            this.populateCompanyProfile(c);
          }
        });
      }
    });
  }

  private populateCompanyProfile(c: CompanyProfile): void {
    this.companyId = c.id ?? '';
    this.logoUrl = c.logoUrl ?? '';
    this.logoIconUrl = c.logoIconUrl ?? '';
    this.bannerUrl = c.bannerUrl ?? '';
    this.companyProfileForm.patchValue({
      companyTitle: c.name ?? '',
      logo: c.logoUrl,
      logoIcon: c.logoIconUrl,
      banner: c.bannerUrl
    });
  }
}
