import { Component, OnInit, Renderer2 } from '@angular/core';
import {
  ReactiveFormsModule,
  UntypedFormBuilder,
  UntypedFormGroup,
  Validators,
} from '@angular/forms';
import { BaseComponent } from '../base.component';
import { Router, RouterModule } from '@angular/router';
import { UserAuth } from '@core/domain-classes/user-auth';
import { SecurityService } from '@core/security/security.service';

import { ToastrService } from '@core/services/toastr-service';
import { CommonError } from '@core/error-handler/common-error';
import { CommonService } from '@core/services/common.service';
import { TranslateModule } from '@ngx-translate/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
  standalone: true,
  imports: [
    ReactiveFormsModule,
    RouterModule,
    TranslateModule,
    MatButtonModule,
    MatIconModule,
    MatProgressSpinnerModule
  ]
})
export class LoginComponent extends BaseComponent implements OnInit {
  logoUrl?: string;
  loginFormGroup: UntypedFormGroup;
  isLoading = false;
  lat: number;
  lng: number;
  showPassword = false;
  logoError = false;

  companyTitle?: string;

  constructor(
    private fb: UntypedFormBuilder,
    private router: Router,
    private securityService: SecurityService,
    private toastr: ToastrService,
    private renderer: Renderer2,
    private commonService: CommonService
  ) {
    super();
  }

  ngOnInit(): void {
    this.createFormGroup();
    this.getCompanyProfile();
    navigator.geolocation.getCurrentPosition(
      (position) => {
        this.lat = position.coords.latitude;
        this.lng = position.coords.longitude;
      },
      () => {
        // Geolocation fallback
      }
    );
  }

  togglePasswordVisibility(): void {
    this.showPassword = !this.showPassword;
  }

  onLogoError(): void {
    this.logoError = true;
  }

  onLoginSubmit() {
    if (this.loginFormGroup.valid) {
      this.isLoading = true;
      const userObject = {
        ...this.loginFormGroup.value,
        latitude: this.lat,
        longitude: this.lng,
      };
      this.sub$.sink = this.securityService.login(userObject).subscribe({
        next: (c: UserAuth) => {
          this.isLoading = false;
          this.getAllAllowFileExtension();
          this.toastr.success(
            this.translationService.getValue('USER_LOGIN_SUCCESSFULLY')
          );
          if (this.securityService.hasClaim('view_dashboard')) {
            this.router.navigate(['/dashboard']);
          } else if (this.securityService.hasClaim('view_documents')) {
            this.router.navigate(['/documents/list-view']);
          } else {
            this.router.navigate(['/assign/list-view']);
          }
        },
        error: (err: any) => {
          this.isLoading = false;
          if (err?.error?.messages) {
            err.error.messages.forEach((msg: string) => {
              this.toastr.error(msg);
            });
          } else {
            this.toastr.error(err?.message || 'Login failed. Please check your credentials.');
          }
        },
      });
    }
  }

  createFormGroup(): void {
    this.loginFormGroup = this.fb.group({
      userName: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required]],
    });
  }

  onRegistrationClick(): void {
    this.router.navigate(['/registration']);
  }

  setBackgroundImage(url: string): void {
    const authBg = document.querySelector('.auth-bg');
    if (authBg && url) {
      this.renderer.setStyle(authBg, 'background-image', `url(${url})`);
    }
  }

  getCompanyProfile(): void {
    this.securityService.companyProfile.subscribe((c: any) => {
      if (c) {
        this.logoUrl = c.logoUrl;
        this.companyTitle = c.companyTitle || c.name;
        if (c?.bannerUrl) {
          this.setBackgroundImage(c.bannerUrl);
        }
      }
    });
  }

  getAllAllowFileExtension() {
    this.commonService
      .getAllowFileExtensions()
      .subscribe();
  }
}
