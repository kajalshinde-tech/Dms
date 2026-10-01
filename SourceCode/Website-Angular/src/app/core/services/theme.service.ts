import { Injectable, signal } from '@angular/core';

export type SidebarActiveStyle = 'filled' | 'light' | 'left-indicator' | 'pill';

export interface SidebarActiveOption {
  id: SidebarActiveStyle;
  name: string;
  description: string;
}

export const SIDEBAR_ACTIVE_STYLES: SidebarActiveOption[] = [
  { id: 'filled', name: 'Filled', description: 'Solid primary fill' },
  { id: 'light', name: 'Light Background', description: 'Soft primary background' },
  { id: 'left-indicator', name: 'Left Indicator', description: 'Left vertical border accent' },
  { id: 'pill', name: 'Pill', description: 'Curved pill badge shape' },
];

export interface ThemeConfig {
  primaryColor: string;
  sidebarBg: string;
  topbarBg: string;
  fontFamily: string;
  sidebarActiveStyle?: SidebarActiveStyle;
}

export const THEME_FONTS = [
  { id: 'roboto', name: 'Roboto', family: "'Roboto', sans-serif", preview: 'Clean & Classic' },
  { id: 'inter', name: 'Inter', family: "'Inter', sans-serif", preview: 'Modern UI' },
  { id: 'poppins', name: 'Poppins', family: "'Poppins', sans-serif", preview: 'Geometric' },
  { id: 'outfit', name: 'Outfit', family: "'Outfit', sans-serif", preview: 'Sleek & Tech' },
  { id: 'plus-jakarta', name: 'Plus Jakarta', family: "'Plus Jakarta Sans', sans-serif", preview: 'Refined SaaS' },
  { id: 'montserrat', name: 'Montserrat', family: "'Montserrat', sans-serif", preview: 'Bold & Elegant' },
];

export const DEFAULT_THEME: ThemeConfig = {
  primaryColor: '#059669', // DoxCraft Emerald Green
  sidebarBg: '#1e293b',   // Modern Dark Slate
  topbarBg: '#ffffff',    // Clean White
  fontFamily: "'Roboto', sans-serif",
  sidebarActiveStyle: 'filled',
};

export const THEME_PALETTES = {
  primary: [
    { name: 'Emerald', color: '#059669' },
    { name: 'Cyan', color: '#00bcd4' },
    { name: 'Blue', color: '#3b82f6' },
    { name: 'Indigo', color: '#6366f1' },
    { name: 'Purple', color: '#8b5cf6' },
    { name: 'Coral', color: '#ef4444' },
    { name: 'Teal', color: '#0d9488' },
    { name: 'Magenta', color: '#d946ef' },
    { name: 'Lime', color: '#84cc16' },
    { name: 'Orange', color: '#f97316' },
  ],
  sidebar: [
    { name: 'White', color: '#ffffff' },
    { name: 'Xintra Navy', color: '#111c43' },
    { name: 'Slate Dark', color: '#1e293b' },
    { name: 'Deep Blue', color: '#1e3a8a' },
    { name: 'Deep Purple', color: '#3b0764' },
    { name: 'Deep Emerald', color: '#064e3b' },
    { name: 'Deep Teal', color: '#0e7490' },
  ],
  topbar: [
    { name: 'White', color: '#ffffff' },
    { name: 'Dark Navy', color: '#111c2e' },
    { name: 'Slate Dark', color: '#1e293b' },
    { name: 'Deep Blue', color: '#1e3a8a' },
    { name: 'Deep Purple', color: '#3b0764' },
    { name: 'Deep Emerald', color: '#064e3b' },
    { name: 'Deep Teal', color: '#0e7490' },
  ],
};

@Injectable({
  providedIn: 'root',
})
export class ThemeService {
  private readonly STORAGE_KEY = 'app_theme_config';
  currentTheme = signal<ThemeConfig>(this.loadStoredTheme());
  isThemeDrawerOpen = signal<boolean>(false);

  constructor() {
    this.applyTheme(this.currentTheme());
  }

  toggleThemeDrawer(): void {
    this.isThemeDrawerOpen.update((v) => !v);
  }

  openThemeDrawer(): void {
    this.isThemeDrawerOpen.set(true);
  }

  closeThemeDrawer(): void {
    this.isThemeDrawerOpen.set(false);
  }

  initTheme(): void {
    const config = this.loadStoredTheme();
    this.applyTheme(config);
  }

  setPrimaryColor(color: string): void {
    const updated = { ...this.currentTheme(), primaryColor: color };
    this.updateTheme(updated);
  }

  setSidebarBg(color: string): void {
    const updated = { ...this.currentTheme(), sidebarBg: color };
    this.updateTheme(updated);
  }

  setTopbarBg(color: string): void {
    const updated = { ...this.currentTheme(), topbarBg: color };
    this.updateTheme(updated);
  }

  setFontFamily(fontFamily: string): void {
    const updated = { ...this.currentTheme(), fontFamily };
    this.updateTheme(updated);
  }

  setSidebarActiveStyle(sidebarActiveStyle: SidebarActiveStyle): void {
    const updated = { ...this.currentTheme(), sidebarActiveStyle };
    this.updateTheme(updated);
  }

  resetTheme(): void {
    this.updateTheme(DEFAULT_THEME);
  }

  private updateTheme(config: ThemeConfig): void {
    this.currentTheme.set(config);
    localStorage.setItem(this.STORAGE_KEY, JSON.stringify(config));
    this.applyTheme(config);
  }

  private loadStoredTheme(): ThemeConfig {
    try {
      const stored = localStorage.getItem(this.STORAGE_KEY);
      if (stored) {
        return { ...DEFAULT_THEME, ...JSON.parse(stored) };
      }
    } catch {
      // ignore
    }
    return DEFAULT_THEME;
  }

  applyTheme(config: ThemeConfig): void {
    const root = document.documentElement;
    const primary = config.primaryColor;
    const hover = this.darkenColor(primary, 12);
    const active = this.darkenColor(primary, 22);
    const light = this.hexToRgba(primary, 0.14);
    const lighter = this.hexToRgba(primary, 0.07);
    const border = this.hexToRgba(primary, 0.35);
    const shadow = `0 4px 14px 0 ${this.hexToRgba(primary, 0.35)}`;
    const rgb = this.hexToRgbValues(primary);
    const contrast = this.getContrastColor(primary);
    const font = config.fontFamily || DEFAULT_THEME.fontFamily;
    const activeStyle: SidebarActiveStyle = config.sidebarActiveStyle || 'filled';

    // Standard SaaS CSS Tokens
    root.style.setProperty('--primary-color', primary);
    root.style.setProperty('--primary-hover', hover);
    root.style.setProperty('--primary-active', active);
    root.style.setProperty('--primary-light', light);
    root.style.setProperty('--primary-lighter', lighter);
    root.style.setProperty('--primary-border', border);
    root.style.setProperty('--primary-contrast', contrast);
    root.style.setProperty('--primary-rgb', rgb);
    root.style.setProperty('--primary-shadow', shadow);

    // Dynamic Font Family Variable
    root.style.setProperty('--app-font-family', font);
    root.style.setProperty('--bs-body-font-family', font);
    root.style.setProperty('--bs-font-sans-serif', font);
    root.style.fontFamily = font;
    if (document.body) {
      document.body.style.setProperty('font-family', font, 'important');
    }

    // Dynamic Sidebar Active Style Variable & Attributes
    root.setAttribute('data-sidebar-active', activeStyle);
    document.body?.setAttribute('data-sidebar-active', activeStyle);
    root.style.setProperty('--app-sidebar-active-style', activeStyle);

    const styleClasses = ['sidebar-active-filled', 'sidebar-active-light', 'sidebar-active-left-indicator', 'sidebar-active-pill'];
    styleClasses.forEach(cls => {
      root.classList.remove(cls);
      document.body?.classList.remove(cls);
    });
    root.classList.add(`sidebar-active-${activeStyle}`);
    document.body?.classList.add(`sidebar-active-${activeStyle}`);

    // App Aliases for Complete Compatibility
    root.style.setProperty('--app-primary-color', primary);
    root.style.setProperty('--app-primary-hover', hover);
    root.style.setProperty('--app-primary-light', light);
    root.style.setProperty('--app-primary-shadow', shadow);
    root.style.setProperty('--app-sidebar-bg', config.sidebarBg);
    root.style.setProperty('--app-topbar-bg', config.topbarBg);

    const isSidebarLight = this.isLightColor(config.sidebarBg);
    const isTopbarLight = this.isLightColor(config.topbarBg);

    // Sidebar Light/Dark text mode class & variables
    if (isSidebarLight) {
      root.classList.add('sidebar-light-mode');
      root.classList.remove('sidebar-dark-mode');
      document.body?.classList.add('sidebar-light-mode');
      document.body?.classList.remove('sidebar-dark-mode');

      root.style.setProperty('--app-sidebar-text', '#334155');
      root.style.setProperty('--app-sidebar-icon', '#64748b');
      root.style.setProperty('--app-sidebar-hover-bg', 'rgba(0, 0, 0, 0.05)');
      root.style.setProperty('--app-sidebar-header-color', '#64748b');
      root.style.setProperty('--app-sidebar-border', '#e2e8f0');
    } else {
      root.classList.add('sidebar-dark-mode');
      root.classList.remove('sidebar-light-mode');
      document.body?.classList.add('sidebar-dark-mode');
      document.body?.classList.remove('sidebar-light-mode');

      root.style.setProperty('--app-sidebar-text', '#cbd5e1');
      root.style.setProperty('--app-sidebar-icon', '#94a3b8');
      root.style.setProperty('--app-sidebar-hover-bg', 'rgba(255, 255, 255, 0.08)');
      root.style.setProperty('--app-sidebar-header-color', '#8c98ad');
      root.style.setProperty('--app-sidebar-border', 'rgba(255, 255, 255, 0.07)');
    }

    // Topbar Light/Dark text mode class & variables
    if (isTopbarLight) {
      root.classList.add('topbar-light-mode');
      root.classList.remove('topbar-dark-mode');
      document.body?.classList.add('topbar-light-mode');
      document.body?.classList.remove('topbar-dark-mode');

      root.style.setProperty('--app-topbar-text', '#0f172a');
      root.style.setProperty('--app-topbar-icon', '#475569');
      root.style.setProperty('--app-topbar-btn-bg', '#f8fafc');
      root.style.setProperty('--app-topbar-btn-border', '#e2e8f0');
      root.style.setProperty('--app-topbar-btn-hover-bg', '#f1f5f9');
      root.style.setProperty('--app-topbar-btn-hover-border', '#cbd5e1');
      root.style.setProperty('--app-topbar-border', '#e9edf4');
    } else {
      root.classList.add('topbar-dark-mode');
      root.classList.remove('topbar-light-mode');
      document.body?.classList.add('topbar-dark-mode');
      document.body?.classList.remove('topbar-light-mode');

      root.style.setProperty('--app-topbar-text', '#ffffff');
      root.style.setProperty('--app-topbar-icon', '#ffffff');
      root.style.setProperty('--app-topbar-btn-bg', 'rgba(255, 255, 255, 0.12)');
      root.style.setProperty('--app-topbar-btn-border', 'rgba(255, 255, 255, 0.18)');
      root.style.setProperty('--app-topbar-btn-hover-bg', 'rgba(255, 255, 255, 0.22)');
      root.style.setProperty('--app-topbar-btn-hover-border', 'rgba(255, 255, 255, 0.35)');
      root.style.setProperty('--app-topbar-border', 'rgba(255, 255, 255, 0.1)');
    }
  }

  private hexToRgba(hex: string, alpha: number): string {
    let clean = (hex || '').replace('#', '');
    if (clean.length === 3) {
      clean = clean.split('').map(c => c + c).join('');
    }
    const r = parseInt(clean.slice(0, 2), 16) || 0;
    const g = parseInt(clean.slice(2, 4), 16) || 0;
    const b = parseInt(clean.slice(4, 6), 16) || 0;
    return `rgba(${r}, ${g}, ${b}, ${alpha})`;
  }

  private hexToRgbValues(hex: string): string {
    let clean = (hex || '').replace('#', '');
    if (clean.length === 3) {
      clean = clean.split('').map(c => c + c).join('');
    }
    const r = parseInt(clean.slice(0, 2), 16) || 0;
    const g = parseInt(clean.slice(2, 4), 16) || 0;
    const b = parseInt(clean.slice(4, 6), 16) || 0;
    return `${r}, ${g}, ${b}`;
  }

  darkenColor(hex: string, percent: number): string {
    let clean = (hex || '').replace('#', '');
    if (clean.length === 3) {
      clean = clean.split('').map(c => c + c).join('');
    }
    let r = parseInt(clean.slice(0, 2), 16) || 0;
    let g = parseInt(clean.slice(2, 4), 16) || 0;
    let b = parseInt(clean.slice(4, 6), 16) || 0;
    r = Math.max(0, Math.floor(r * (1 - percent / 100)));
    g = Math.max(0, Math.floor(g * (1 - percent / 100)));
    b = Math.max(0, Math.floor(b * (1 - percent / 100)));
    return `#${r.toString(16).padStart(2, '0')}${g.toString(16).padStart(2, '0')}${b.toString(16).padStart(2, '0')}`;
  }

  isLightColor(hex: string): boolean {
    if (!hex) return true;
    let clean = hex.trim().toLowerCase();
    if (clean === '#ffffff' || clean === '#fff' || clean === 'white') return true;
    if (clean.startsWith('#')) clean = clean.slice(1);
    if (clean.length === 3) {
      clean = clean.split('').map(c => c + c).join('');
    }
    const r = parseInt(clean.slice(0, 2), 16) || 0;
    const g = parseInt(clean.slice(2, 4), 16) || 0;
    const b = parseInt(clean.slice(4, 6), 16) || 0;
    const brightness = (r * 299 + g * 587 + b * 114) / 1000;
    return brightness > 155;
  }

  private getContrastColor(hex: string): string {
    return this.isLightColor(hex) ? '#0f172a' : '#ffffff';
  }
}
