import {
  Component,
  ElementRef,
  OnInit,
  Renderer2,
  HostListener,
  ChangeDetectorRef,
  Inject,
  DOCUMENT
} from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { Router, RouterModule } from '@angular/router';
import { LanguageFlag } from '@core/domain-classes/language-flag';
import { UserNotification } from '@core/domain-classes/notification';
import { UserAuth } from '@core/domain-classes/user-auth';
import { SecurityService } from '@core/security/security.service';
import { CategoryService } from '@core/services/category.service';
import { ClonerService } from '@core/services/clone.service';
import { CommonService } from '@core/services/common.service';
import { SignalrService } from '@core/services/signalr.service';
import { WINDOW, WINDOW_PROVIDERS } from '@core/services/window.service';
import { TranslateModule } from '@ngx-translate/core';
import { UTCToLocalTime } from '@shared/pipes/utc-to-localtime.pipe';
import { NgScrollbarModule } from 'ngx-scrollbar';
import { BaseComponent } from '../../base.component';
import { NotificationService } from '../../notification/notification.service';
import { NgClass } from '@angular/common';
import { MatBadgeModule } from '@angular/material/badge';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { ThemeService, THEME_PALETTES, THEME_FONTS, SIDEBAR_ACTIVE_STYLES, SidebarActiveStyle } from '@core/services/theme.service';
import { inject } from '@angular/core';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss'],
  standalone: true,
  imports: [
    RouterModule,
    TranslateModule,
    MatMenuModule,
    NgScrollbarModule,
    MatIconModule,
    MatButtonModule,
    UTCToLocalTime,
    NgClass,
    MatBadgeModule,
    MatSelectModule,
    MatFormFieldModule
  ],
  providers: [
    WINDOW_PROVIDERS
  ]
})
export class HeaderComponent extends BaseComponent implements OnInit {
  logoUrl?: string;
  logoIconUrl?: string;
  isNavbarCollapsed = true;
  isNavbarShow = true;
  isOpenSidebar?: boolean;
  isFullScreen = false;
  docElement?: HTMLElement;
  appUserAuth!: UserAuth;

  public themeService = inject(ThemeService);
  themePalettes = THEME_PALETTES;
  themeFonts = THEME_FONTS;
  sidebarActiveStyles = SIDEBAR_ACTIVE_STYLES;

  get isThemeDrawerOpen(): boolean {
    return this.themeService.isThemeDrawerOpen();
  }

  toggleThemeDrawer(): void {
    this.themeService.toggleThemeDrawer();
  }

  closeThemeDrawer(): void {
    this.themeService.closeThemeDrawer();
  }

  setPrimaryColor(color: string): void {
    this.themeService.setPrimaryColor(color);
  }

  setSidebarBg(color: string): void {
    this.themeService.setSidebarBg(color);
  }

  setSidebarActiveStyle(style: SidebarActiveStyle): void {
    this.themeService.setSidebarActiveStyle(style);
  }

  setTopbarBg(color: string): void {
    this.themeService.setTopbarBg(color);
  }

  setFontFamily(font: string): void {
    this.themeService.setFontFamily(font);
  }

  onResetTheme(): void {
    this.themeService.resetTheme();
  }

  isPresetColor(list: { name: string; color: string }[], color: string): boolean {
    return list.some(item => item.color.toLowerCase() === color?.toLowerCase());
  }

  onCustomSidebarChange(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input?.value) {
      this.setSidebarBg(input.value);
    }
  }

  onCustomTopbarChange(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input?.value) {
      this.setTopbarBg(input.value);
    }
  }

  onCustomPrimaryChange(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input?.value) {
      this.setPrimaryColor(input.value);
    }
  }

  onFontChange(event: Event): void {
    const select = event.target as HTMLSelectElement;
    if (select && select.value) {
      this.setFontFamily(select.value);
    }
  }

  getSelectedFontName(): string {
    const current = this.themeService.currentTheme().fontFamily;
    const match = this.themeFonts.find(f => f.family === current);
    return match ? match.name : 'Roboto';
  }

  getUserFullName(): string {
    if (this.appUserAuth) {
      if (this.appUserAuth.firstName) {
        return `${this.appUserAuth.firstName} ${this.appUserAuth.lastName || ''}`.trim();
      }
      if (this.appUserAuth.userName) {
        return this.appUserAuth.userName;
      }
    }
    return 'User Profile';
  }

  getUserRoleOrEmail(): string {
    if (this.appUserAuth) {
      if (this.appUserAuth.isSuperAdmin) {
        return 'Administrator';
      }
      if (this.appUserAuth.email) {
        return this.appUserAuth.email;
      }
    }
    return 'User';
  }
  newNotificationCount = 0;
  notifications: UserNotification[] = [];
  language!: LanguageFlag | undefined;
  direction = 'ltr';
  hasClass = false;
  oldLang: string = '';
  languages: LanguageFlag[] = [
    {
      code: 'en',
      name: 'English',
      imageUrl: '../../../images/flags/united-states.svg',
      isrtl: false
    },
    {
      code: 'es',
      name: 'Spanish ',
      imageUrl: '../../../images/flags/brazil.svg',
      isrtl: false
    },
    {
      code: 'fr',
      name: 'French ',
      imageUrl: '../../../images/flags/france.svg',
      isrtl: false
    },
    {
      code: 'ar',
      name: 'Arabic ',
      imageUrl: '../../../images/flags/saudi-arabia.svg',
      isrtl: true
    },
    {
      code: 'tr',
      name: 'Turkish',
      imageUrl: '../../../images/flags/turkish.png',
      isrtl: false
    },
    {
      code: 'pl',
      name: 'Polish',
      imageUrl: '../../../images/flags/polish.jpeg',
      isrtl: false
    },
    {
      code: 'ru',
      name: 'Russian',
      imageUrl: '../../../images/flags/russia.svg',
      isrtl: false
    },
    {
      code: 'ja',
      name: 'Japanese',
      imageUrl: '../../../images/flags/japan.svg',
      isrtl: false
    },
    {
      code: 'ko',
      name: 'Korean',
      imageUrl: '../../../images/flags/south-korea.svg',
      isrtl: false
    },
    {
      code: 'cn',
      name: 'Chinese',
      imageUrl: '../../../images/flags/china.svg',
      isrtl: false
    }
  ];
  constructor(
    @Inject(DOCUMENT) private document: Document,
    @Inject(WINDOW) private window: Window,
    private renderer: Renderer2,
    public elementRef: ElementRef,
    private router: Router,
    private securityService: SecurityService,
    private notificationService: NotificationService,
    private signalrService: SignalrService,
    private cd: ChangeDetectorRef,
    private commonService: CommonService,
    private clonerService: ClonerService,
    private categoryService: CategoryService,
  ) {
    super();
  }


  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.window.pageYOffset ||
      this.document.documentElement.scrollTop ||
      this.document.body.scrollTop ||
      0;
  }

  ngOnInit() {
    this.docElement = document.documentElement;
    this.sidebarMenuStatus();
    this.setTopLogAndName();
    this.subscribeToNotification();
    this.setDefaultLanguage();
    this.getCompanyProfile();

  }


  sidebarMenuStatus() {
    this.sub$.sink = this.commonService.sideMenuStatus$.subscribe((status) => {
      this.isOpenSidebar = status;
    });
  }

  callFullscreen() {
    if (!this.isFullScreen) {
      if (this.docElement?.requestFullscreen != null) {
        this.docElement?.requestFullscreen();
      }
    } else {
      document.exitFullscreen();
    }
    this.isFullScreen = !this.isFullScreen;
  }

  mobileMenuSidebarOpen(event: Event, className = 'overlay-open') {
    if (event) {
      event.stopPropagation();
      event.preventDefault();
    }
    const hasClass = this.document.body.classList.contains(className);
    if (hasClass) {
      this.renderer.removeClass(this.document.body, className);
    } else {
      this.renderer.addClass(this.document.body, className);
    }
  }

  callSidemenuCollapse() {
    const hasClass = this.document.body.classList.contains('side-closed');
    if (hasClass) {
      this.commonService.setSideMenuStatus(false);
      this.renderer.removeClass(this.document.body, 'side-closed');
      this.renderer.removeClass(this.document.body, 'submenu-closed');
      localStorage.setItem('collapsed_menu', 'false');
    } else {
      this.renderer.addClass(this.document.body, 'side-closed');
      this.renderer.addClass(this.document.body, 'submenu-closed');
      localStorage.setItem('collapsed_menu', 'true');
      this.commonService.setSideMenuStatus(true);
    }
  }

  setDefaultLanguage() {
    const lang = this.translationService.getSelectedLanguage();
    if (lang) this.setLanguageWithRefresh(lang);
  }

  setLanguageWithRefresh(code: string) {
    this.language = this.languages.find((c) => c.code == code);
    this.languages.forEach((language: LanguageFlag) => {
      if (language.code === code) {
        language.active = true;
      } else {
        language.active = false;
      }
    });
    if (this.language)
      this.translationService.setLanguage(this.language);
  }
  setLanguageWithRefreshNew(languageflag: LanguageFlag) {
    this.languages.forEach((language: LanguageFlag) => {
      if (language.code === languageflag.code) {
        language.active = true;
        this.language = languageflag;
      } else {
        languageflag.active = false;
      }
    });
    this.translationService.setLanguage(languageflag);
  }

  setNewLanguageRefresh(language: LanguageFlag) {
    this.oldLang = this.translationService.getSelectedLanguage();
    this.sub$.sink = this.translationService
      .setLanguage(language)
      .subscribe((response: any) => {
        if (response)
          this.setLanguageWithRefreshNew(language);
      });
  }

  setTopLogAndName() {
    this.sub$.sink = this.securityService.SecurityObject.subscribe((c) => {
      if (c) {
        this.appUserAuth = c;
      }
    });
  }

  onLogout(): void {
    this.securityService.logout();
    sessionStorage.removeItem('workflows');
    sessionStorage.removeItem(this.categoryService.categoryKey);
    location.reload();
  }

  onMyProfile(): void {
    this.router.navigate(['/my-profile']);
  }

  subscribeToNotification() {
    this.sub$.sink = this.signalrService.userNotification$.subscribe((c) => {
      this.getNotification();
    });
  }

  getNotification() {
    this.sub$.sink = this.notificationService
      .getNotification()
      .subscribe((notifications: UserNotification[]) => {
        const unreadCount = notifications.filter((c) => !c.isRead).length;
        this.newNotificationCount = unreadCount;
        this.notifications =
          this.clonerService.deepClone<UserNotification[]>(notifications);
        this.cd.detectChanges();
      });
  }


  markAllAsReadNotification() {
    this.sub$.sink = this.notificationService.markAllAsRead().subscribe(() => {
      this.getNotification();
    });
  }

  viewAllNotification() {
    this.sub$.sink = this.notificationService.markAllAsRead().subscribe(() => {
      this.router.navigate(['/notifications']);
    });
  }

  viewNotification(notification: UserNotification) {
    if (!notification.isRead) {
      this.markAsReadNotification(notification.id ?? '');
    }
    if (notification.notificationsType === 2) {
      this.router.navigate(['/current-workflow']);
    }
    else if (notification.notificationsType === 3) {
      this.router.navigate(['/file-request']);
    }
    else if (notification.notificationsType === 4) {
      this.router.navigate(['/assign/folder-view']);
    }
    else if (notification.documentId) {
      this.router.navigate(['/']);
    } 
    else {
      this.router.navigate(['reminders']);
    }
  }

  markAsReadNotification(id: string) {
    this.sub$.sink = this.notificationService.markAsRead(id).subscribe(() => {
      this.getNotification();
    });
  }

  getCompanyProfile(): void {
    this.securityService.companyProfile.subscribe((c) => {
      if (c) {
        this.logoUrl = c.logoUrl;
        this.logoIconUrl = c.logoIconUrl;
      }
    });
  }
}
