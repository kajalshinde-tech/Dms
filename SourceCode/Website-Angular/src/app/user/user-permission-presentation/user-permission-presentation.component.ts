import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { User } from '@core/domain-classes/user';
import { MatCheckboxChange, MatCheckboxModule } from '@angular/material/checkbox';
import { Page } from '@core/domain-classes/page';
import { Action } from '@core/domain-classes/action';
import { HasClaimDirective } from '@shared/has-claim.directive';
import { RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-user-permission-presentation',
  templateUrl: './user-permission-presentation.component.html',
  styleUrls: ['./user-permission-presentation.component.scss'],
  standalone: true,
  imports: [
    HasClaimDirective,
    MatCheckboxModule,
    RouterModule,
    TranslateModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatTooltipModule
  ]
})
export class UserPermissionPresentationComponent implements OnInit {
  @Input() pages: Page[];
  @Input() user: User;
  @Output() manageUserClaimAction: EventEmitter<User> = new EventEmitter<User>();
  step: number = 0;

  constructor() { }

  ngOnInit(): void { }

  checkPermission(actionId: string): boolean {
    const pageAction = this.user?.userClaims?.find(c => c.pageActionId === actionId);
    return !!pageAction;
  }

  isPageAllSelected(page: Page): boolean {
    if (!page?.pageActions || page.pageActions.length === 0) return false;
    return page.pageActions.every(action => this.checkPermission(action.id));
  }

  isPageIndeterminate(page: Page): boolean {
    if (!page?.pageActions || page.pageActions.length === 0) return false;
    const count = this.getSelectedActionCount(page);
    return count > 0 && count < page.pageActions.length;
  }

  getSelectedActionCount(page: Page): number {
    if (!page?.pageActions) return 0;
    return page.pageActions.filter(action => this.checkPermission(action.id)).length;
  }

  isAllSelected(): boolean {
    if (!this.pages || this.pages.length === 0) return false;
    return this.pages.every(page => this.isPageAllSelected(page));
  }

  isIndeterminate(): boolean {
    if (!this.pages || this.pages.length === 0) return false;
    const totalActions = this.pages.reduce((acc, p) => acc + (p.pageActions?.length || 0), 0);
    const selectedCount = this.pages.reduce((acc, p) => acc + this.getSelectedActionCount(p), 0);
    return selectedCount > 0 && selectedCount < totalActions;
  }

  onPermissionChange(flag: any, page: Page, action: Action) {
    if (flag.checked) {
      this.user?.userClaims?.push({
        userId: this.user.id,
        claimType: action.code,
        claimValue: '',
        pageActionId: action.id,
        pageId: page.id
      });
    } else {
      const roleClaimToRemove = this.user?.userClaims?.find(c => c.pageActionId === action.id);
      if (roleClaimToRemove) {
        const index = this.user?.userClaims?.indexOf(roleClaimToRemove, 0);
        if (typeof index === 'number' && index > -1) {
          this.user?.userClaims?.splice(index, 1);
        }
      }
    }
  }

  onPageSelect(event: MatCheckboxChange, page: Page) {
    if (event.checked) {
      page.pageActions.forEach(action => {
        if (!this.checkPermission(action.id)) {
          this.user.userClaims?.push({
            userId: this.user.id,
            claimType: action.code,
            claimValue: '',
            pageActionId: action.id,
            pageId: page.id
          });
        }
      });
    } else {
      const actions = page.pageActions?.map(c => c.id);
      this.user.userClaims = this.user.userClaims?.filter(c => actions.indexOf(c.pageActionId) < 0);
    }
  }

  saveUserClaim() {
    this.manageUserClaimAction.emit(this.user);
  }

  selecetAll(event: MatCheckboxChange) {
    if (event.checked) {
      this.pages.forEach(page => {
        page.pageActions.forEach(action => {
          if (!this.checkPermission(action.id)) {
            this.user.userClaims?.push({
              userId: this.user.id,
              claimType: action.code,
              claimValue: '',
              pageActionId: action.id,
              pageId: page.id
            });
          }
        });
      });
    } else {
      this.user.userClaims = [];
    }
  }
}
