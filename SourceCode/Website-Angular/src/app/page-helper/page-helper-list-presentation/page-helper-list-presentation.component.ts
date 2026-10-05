import { Component, Input, OnInit, ViewChild, AfterViewInit } from '@angular/core';
import { PageHelper } from '@core/domain-classes/pageHelper';
import { BaseComponent } from '../../base.component';
import { Router, RouterModule } from '@angular/router';
import { PageHelpPreviewComponent } from '@shared/page-help-preview/page-help-preview.component';
import { CommonService } from '@core/services/common.service';
import { MatDialog } from '@angular/material/dialog';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { TranslateModule } from '@ngx-translate/core';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatTooltipModule } from '@angular/material/tooltip';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-page-helper-list-presentation',
  templateUrl: './page-helper-list-presentation.component.html',
  styleUrls: ['./page-helper-list-presentation.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
    MatTableModule,
    MatPaginatorModule,
    TranslateModule,
    RouterModule,
    MatIconModule,
    MatButtonModule,
    MatCardModule,
    MatTooltipModule,
    FormsModule
  ]
})
export class PageHelperListPresentationComponent
  extends BaseComponent
  implements OnInit, AfterViewInit {
  
  @ViewChild(MatPaginator) paginator!: MatPaginator;

  dataSource = new MatTableDataSource<PageHelper>([]);
  searchValue: string = '';
  columnsToDisplay: string[] = ['action', 'name', 'code'];

  @Input() set pageHelpers(value: PageHelper[] | null) {
    this._pageHelpers = value || [];
    this.dataSource.data = this._pageHelpers;
    if (this.paginator) {
      this.dataSource.paginator = this.paginator;
    }
  }
  get pageHelpers(): PageHelper[] {
    return this._pageHelpers;
  }
  private _pageHelpers: PageHelper[] = [];

  constructor(
    private router: Router,
    private commonService: CommonService,
    private dialog: MatDialog
  ) {
    super();
    this.dataSource.filterPredicate = (data: PageHelper, filter: string) => {
      const nameMatch = data.name?.toLowerCase().includes(filter) ?? false;
      const codeMatch = data.code?.toLowerCase().includes(filter) ?? false;
      return nameMatch || codeMatch;
    };
  }

  ngOnInit(): void { }

  ngAfterViewInit(): void {
    this.dataSource.paginator = this.paginator;
  }

  applyFilter(event: Event | string): void {
    const filterValue = typeof event === 'string' ? event : (event.target as HTMLInputElement).value;
    this.searchValue = filterValue;
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }

  clearSearch(): void {
    this.searchValue = '';
    this.dataSource.filter = '';
  }

  viewPageHelper(pageHelper: PageHelper): void {
    this.commonService
      .getPageHelperText(pageHelper.code ?? '')
      .subscribe((help: PageHelper) => {
        this.dialog.open(PageHelpPreviewComponent, {
          width: '100%',
          maxWidth: '680px',
          data: Object.assign({}, help),
        });
      });
  }

  managePageHelper(pageHelper: PageHelper) {
    this.router.navigate(['/page-helper/manage', pageHelper.id]);
  }
}
