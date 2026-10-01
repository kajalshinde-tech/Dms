import { Component, OnInit, inject, OnDestroy, Input, ViewChild, AfterViewInit } from '@angular/core';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { MatSort, MatSortModule } from '@angular/material/sort';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { FormsModule } from '@angular/forms';
import { SubSink } from 'subsink';

import { ToastrService } from '@core/services/toastr-service';
import { DocumentStatusService } from '../document-status.service';
import { ManageDocumentStatusComponent } from '../manage-document-status/manage-document-status.component';
import { CommonDialogService } from '@core/common-dialog/common-dialog.service';
import { TranslationService } from '@core/services/translation.service';
import { DocumentStatus } from '../document-status';
import { RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-document-status-list',
  imports: [
    RouterModule,
    TranslateModule,
    FormsModule,
    MatTableModule,
    MatSortModule,
    MatPaginatorModule,
    MatDialogModule,
    MatCardModule,
    MatIconModule,
    MatButtonModule,
    MatProgressSpinnerModule,
    MatTooltipModule
  ],
  templateUrl: './document-status-list.component.html',
  styleUrls: ['./document-status-list.component.scss']
})
export class DocumentStatusListComponent implements OnInit, AfterViewInit, OnDestroy {
  @Input() documentStatus: DocumentStatus;
  documentStatuses: DocumentStatus[] = [];
  displayedColumns: string[] = ['action', 'name', 'description', 'colorCode'];
  footerToDisplayed: string[] = ['footer'];
  dataSource = new MatTableDataSource<DocumentStatus>([]);
  searchFilter: string = '';
  isLoadingResults = false;

  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;

  private subs = new SubSink();
  private documentStatusService = inject(DocumentStatusService);
  private dialog = inject(MatDialog);
  private toastrService = inject(ToastrService);
  private translationService = inject(TranslationService);
  private commonDialogService = inject(CommonDialogService);

  constructor() { }

  ngOnInit(): void {
    this.getDocumentStatus();
  }

  ngAfterViewInit(): void {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
    this.dataSource.filterPredicate = (data: DocumentStatus, filter: string) => {
      const searchStr = `${data.name || ''} ${data.description || ''} ${data.colorCode || ''}`.toLowerCase();
      return searchStr.includes(filter.trim().toLowerCase());
    };
  }

  getDocumentStatus(): void {
    this.isLoadingResults = true;
    this.documentStatusService.getDocumentStatuss().subscribe({
      next: (data: DocumentStatus[]) => {
        this.documentStatuses = data;
        this.dataSource.data = data;
        this.isLoadingResults = false;
      },
      error: () => {
        this.isLoadingResults = false;
      },
    });
  }

  applyFilter(filterValue: string): void {
    this.dataSource.filter = filterValue.trim().toLowerCase();
    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  clearFilter(): void {
    this.searchFilter = '';
    this.dataSource.filter = '';
    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  onCreateDocumentStatus(): void {
    const dialogRef = this.dialog.open(ManageDocumentStatusComponent, {
      width: '540px',
      autoFocus: false,
    });
    this.subs.sink = dialogRef.afterClosed().subscribe((result: DocumentStatus) => {
      if (result) {
        this.documentStatuses = [result, ...this.documentStatuses];
        this.dataSource.data = [...this.documentStatuses];
      }
    });
  }

  onEditDocumentStatus(documentStatus: DocumentStatus): void {
    const dialogRef = this.dialog.open(ManageDocumentStatusComponent, {
      width: '540px',
      autoFocus: false,
      data: { ...documentStatus }
    });

    this.subs.sink = dialogRef.afterClosed().subscribe((result: DocumentStatus) => {
      if (result) {
        this.documentStatuses = this.documentStatuses.map(item =>
          item.id === result.id ? { ...item, ...result } : item
        );
        this.dataSource.data = [...this.documentStatuses];
      }
    });
  }

  deleteDocumentStatus(id: string): void {
    this.subs.sink = this.commonDialogService
      .deleteConfirmtionDialog(
        this.translationService.getValue('ARE_YOU_SURE_YOU_WANT_TO_DELETE')
      )
      .subscribe((isConfirmed) => {
        if (isConfirmed) {
          this.isLoadingResults = true;
          this.documentStatusService.deleteDocumentStatus(id).subscribe({
            next: () => {
              this.isLoadingResults = false;
              this.getDocumentStatus();
              this.toastrService.success(
                this.translationService.getValue(
                  'DOCUMENT_STATUS_DELETED_SUCCESSFULLY'
                )
              );
            },
            error: () => {
              this.isLoadingResults = false;
            }
          });
        }
      });
  }

  ngOnDestroy(): void {
    this.subs.unsubscribe();
  }
}
