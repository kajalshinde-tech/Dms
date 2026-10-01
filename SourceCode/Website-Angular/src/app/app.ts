import { Component, inject, OnInit, Renderer2, signal } from '@angular/core';
import { Title } from '@angular/platform-browser';
import {
  NavigationCancel,
  NavigationEnd,
  NavigationError,
  NavigationStart,
  Router,
  RouterOutlet,
} from '@angular/router';
import { SecurityService } from '@core/security/security.service';
import { CommonService } from '@core/services/common.service';
import { SignalrService } from '@core/services/signalr.service';
import { LoadingIndicatorComponent } from '@shared/loading-indicator/loading-indicator.component';
import { LoadingService } from '@shared/loading-indicator/loading-service';

import { ThemeService } from '@core/services/theme.service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, LoadingIndicatorComponent],
  templateUrl: './app.html',
  styleUrl: './app.scss',
})
export class App implements OnInit {
  title = 'document-management';
  logoUrl: string;
  logoIconUrl: string;
  private commonService = inject(CommonService);
  private themeService = inject(ThemeService);
  signalrService = inject(SignalrService);
  loadingService = inject(LoadingService);
  securityService = inject(SecurityService);
  titleService = inject(Title);
  renderer = inject(Renderer2);

  constructor(router: Router) {
    router.events.subscribe((event) => {
      if (event instanceof NavigationStart) {
        this.loadingService.setLoadingFlag(true);
      }
      if (
        event instanceof NavigationError ||
        event instanceof NavigationEnd ||
        event instanceof NavigationCancel
      ) {
        this.loadingService.setLoadingFlag(false);
      }
    });
  }

  ngOnInit(): void {
    this.themeService.initTheme();
    this.getCompanyProfile();
    this.getAllAllowFileExtension();

    this.signalrService.startConnection().then((resolve: any) => {
      if (resolve) {
        this.signalrService.handleMessage();
      }
    }).catch(() => {});
  }

  getAllAllowFileExtension() {
    this.commonService.getAllowFileExtensions().subscribe();
  }

  getCompanyProfile(): void {
    this.securityService.companyProfile.subscribe((c) => {
      if (c) {
        this.titleService.setTitle(c.name ?? 'Document Management');

        if (c.logoIconUrl) {
          this.logoIconUrl = c.logoIconUrl;
          this.setFavicon(this.logoIconUrl);

          localStorage.setItem('companyFavicon', this.logoIconUrl);
        }
      } else {
        const storedFavicon = localStorage.getItem('companyFavicon');
        if (storedFavicon) {
          this.setFavicon(storedFavicon);
        }
      }
    });
  }

  setFavicon(iconUrl: string): void {
    let link = document.querySelector('#appFavicon') as HTMLLinkElement | null;

    if (!link) {
      link = this.renderer.createElement('link');
      this.renderer.setAttribute(link, 'rel', 'icon');
      this.renderer.setAttribute(link, 'id', 'appFavicon');
      this.renderer.appendChild(document.head, link);
    }

    if (link) {
      this.renderer.setAttribute(link, 'href', iconUrl);
      this.renderer.setAttribute(link, 'type', 'image/x-icon');
    }
  }
}
