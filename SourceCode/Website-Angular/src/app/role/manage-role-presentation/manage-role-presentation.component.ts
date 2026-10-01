import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Role } from '@core/domain-classes/role';
import { MatCheckboxChange, MatCheckboxModule } from '@angular/material/checkbox';
import { Action } from '@core/domain-classes/action';
import { Page } from '@core/domain-classes/page';
import { BaseComponent } from '../../base.component';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-manage-role-presentation',
  templateUrl: './manage-role-presentation.component.html',
  styleUrls: ['./manage-role-presentation.component.scss'],
  standalone: true,
  imports: [
    FormsModule,
    MatCheckboxModule,
    RouterLink,
    TranslateModule,
    MatIconModule,
    MatCardModule,
    MatButtonModule,
    MatTooltipModule
  ]
})
export class ManageRolePresentationComponent extends BaseComponent implements OnInit {
  @Input() pages: Page[];
  @Input() loading: boolean;
  @Input() role: Role;
  @Output() onManageRoleAction: EventEmitter<Role> =
    new EventEmitter<Role>();

  constructor() {
    super();
  }

  ngOnInit(): void { }

  onPageSelect(event: MatCheckboxChange, page: Page) {
    if (event.checked) {
      page.pageActions.forEach((action) => {
        if (!this.checkPermission(action.id)) {
          this.role.roleClaims?.push({
            roleId: this.role.id,
            claimType: action.code,
            claimValue: '',
            pageActionId: action.id,
          });
        }
      });
    } else {
      const actions = page.pageActions?.map((c) => c.id);
      this.role.roleClaims = this.role.roleClaims?.filter(
        (c) => actions.indexOf(c.pageActionId) < 0
      );
    }
  }

  selecetAll(event: MatCheckboxChange) {
    if (event.checked) {
      this.pages.forEach((page) => {
        page.pageActions.forEach((action) => {
          if (!this.checkPermission(action.id)) {
            this.role.roleClaims?.push({
              roleId: this.role.id,
              claimType: action.code,
              claimValue: '',
              pageActionId: action.id,
            });
          }
        });
      });
    } else {
      this.role.roleClaims = [];
    }
  }

  checkPermission(actionId: string): boolean {
    const pageAction = this.role.roleClaims?.find(
      (c) => c.pageActionId === actionId
    );
    return !!pageAction;
  }

  isPageAllSelected(page: Page): boolean {
    if (!page?.pageActions || page.pageActions.length === 0) return false;
    return page.pageActions.every((action) => this.checkPermission(action.id));
  }

  isPageIndeterminate(page: Page): boolean {
    if (!page?.pageActions || page.pageActions.length === 0) return false;
    const count = this.getSelectedActionCount(page);
    return count > 0 && count < page.pageActions.length;
  }

  getSelectedActionCount(page: Page): number {
    if (!page?.pageActions) return 0;
    return page.pageActions.filter((action) => this.checkPermission(action.id)).length;
  }

  isAllSelected(): boolean {
    if (!this.pages || this.pages.length === 0) return false;
    return this.pages.every((page) => this.isPageAllSelected(page));
  }

  isIndeterminate(): boolean {
    if (!this.pages || this.pages.length === 0) return false;
    const totalActions = this.pages.reduce((acc, p) => acc + (p.pageActions?.length || 0), 0);
    const selectedCount = this.pages.reduce((acc, p) => acc + this.getSelectedActionCount(p), 0);
    return selectedCount > 0 && selectedCount < totalActions;
  }

  onPermissionChange(flag: any, page: Page, action: Action) {
    if (flag.checked) {
      this.role.roleClaims?.push({
        roleId: this.role.id,
        claimType: action.code,
        claimValue: '',
        pageActionId: action.id,
      });
    } else {
      const roleClaimToRemove = this.role.roleClaims?.find(
        (c) => c.pageActionId === action.id
      );
      if (roleClaimToRemove) {
        const index = this.role.roleClaims?.indexOf(roleClaimToRemove, 0);
        if (index !== undefined && index > -1) {
          this.role.roleClaims?.splice(index, 1);
        }
      }
    }
  }

  saveRole(): void {
    this.onManageRoleAction.emit(this.role);
  }
}
