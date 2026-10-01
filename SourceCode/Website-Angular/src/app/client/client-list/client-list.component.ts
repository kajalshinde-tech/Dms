import { AfterViewInit, Component, effect, inject, OnInit, ViewChild } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { MatSort, MatSortModule } from '@angular/material/sort';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { RouterModule } from '@angular/router';
import { CommonDialogService } from '@core/common-dialog/common-dialog.service';
import { TranslateModule } from '@ngx-translate/core';
import { BaseComponent } from '../../base.component';
import { Client } from '@core/domain-classes/client';
import { ClientStore } from '../client-store';
import { HasClaimDirective } from '@shared/has-claim.directive';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-client-list',
  imports: [
    FormsModule,
    TranslateModule,
    RouterModule,
    ReactiveFormsModule,
    MatTableModule,
    MatSortModule,
    MatPaginatorModule,
    MatInputModule,
    MatProgressSpinnerModule,
    HasClaimDirective,
    MatIconModule,
    MatButtonModule,
    MatCardModule,
    MatTooltipModule
  ],
  templateUrl: './client-list.component.html',
  styleUrl: './client-list.component.scss'
})
export class ClientListComponent extends BaseComponent implements OnInit, AfterViewInit {

  displayedColumns: string[] = ['action', 'companyName', 'contactPerson', 'email', 'phoneNumber'];
  footerToDisplayed: string[] = ['footer'];
  dataSource = new MatTableDataSource<Client>([]);
  searchFilter: string = '';

  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;

  public clientStore = inject(ClientStore);
  private commonDialogService = inject(CommonDialogService);

  constructor() {
    super();
    effect(() => {
      const clients = this.clientStore.clients();
      this.dataSource.data = clients;
    });
  }

  ngOnInit(): void {
    this.getClients();
  }

  ngAfterViewInit(): void {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
    this.dataSource.filterPredicate = (data: Client, filter: string) => {
      const searchStr = `${data.companyName || ''} ${data.contactPerson || ''} ${data.email || ''} ${data.phoneNumber || ''}`.toLowerCase();
      return searchStr.includes(filter.trim().toLowerCase());
    };
  }

  getClients() {
    this.clientStore.loadClients();
  }

  applyFilter(filterValue: string) {
    this.dataSource.filter = filterValue.trim().toLowerCase();
    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  clearFilter() {
    this.searchFilter = '';
    this.dataSource.filter = '';
    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  deleteClient(client: Client) {
    this.sub$.sink = this.commonDialogService
      .deleteConfirmtionDialog(`${this.translationService.getValue('ARE_YOU_SURE_YOU_WANT_TO_DELETE')} ${client.companyName}`)
      .subscribe((isTrue: boolean) => {
        if (isTrue) {
          this.clientStore.deleteClientById(client.id ?? '');
        }
      });
  }
}
