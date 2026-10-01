import { Component, effect, inject, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { Workflow } from '@core/domain-classes/workflow';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { TranslationService } from '@core/services/translation.service';
import { WorkflowStore } from '../workflow-store';
import { CommonDialogService } from '@core/common-dialog/common-dialog.service';
import { SignalrService } from '@core/services/signalr.service';
import { MatDialog } from '@angular/material/dialog';
import { WorkflowService } from '../workflow.service';
import { VisualWorkflowInstance } from '@core/domain-classes/visual-workflow-instance';
import { WorkflowGraphComponent } from '../workflow-graph/workflow-graph.component';
import { ToastrService } from '@core/services/toastr-service';
import { HasClaimDirective } from '@shared/has-claim.directive';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatSort, MatSortModule } from '@angular/material/sort';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';

@Component({
  selector: 'app-workflow-list',
  imports: [
    FormsModule,
    TranslateModule,
    RouterModule,
    MatTableModule,
    HasClaimDirective,
    MatIconModule,
    MatCardModule,
    MatButtonModule,
    MatTooltipModule,
    MatPaginatorModule,
    MatSortModule,
    MatProgressSpinnerModule
  ],
  templateUrl: './workflow-list.component.html',
  styleUrl: './workflow-list.component.scss'
})
export class WorkflowListComponent implements OnInit, OnDestroy {

  searchFilter: string = '';
  dataSource = new MatTableDataSource<Workflow>([]);
  displayedColumns: string[] = ['action', 'name', 'description', 'setupStatus'];
  footerToDisplayed: string[] = ['footer'];

  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;

  private dialog = inject(MatDialog);
  public workflowStore = inject(WorkflowStore);
  private commonDialogService = inject(CommonDialogService);
  private translationService = inject(TranslationService);
  private signalrService = inject(SignalrService);
  private workflowService = inject(WorkflowService);
  private toastrService = inject(ToastrService);

  constructor() {
    effect(() => {
      const list = this.workflowStore.workflows();
      this.dataSource.data = list || [];
      if (this.paginator) {
        this.dataSource.paginator = this.paginator;
      }
      if (this.sort) {
        this.dataSource.sort = this.sort;
      }
    });
  }

  ngOnInit(): void {
    this.getWorkflows();
    this.signalrService.refreshWorkflowSettings$.subscribe(() => {
      this.getWorkflows();
    });
  }

  ngAfterViewInit(): void {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
    this.dataSource.filterPredicate = (data: Workflow, filter: string) => {
      const searchStr = (
        (data.name || '') +
        ' ' +
        (data.description || '') +
        ' ' +
        (data.isWorkflowSetup ? 'completed' : 'draft')
      ).toLowerCase();
      return searchStr.includes(filter.trim().toLowerCase());
    };
  }

  applyFilter(filterValue: string): void {
    this.searchFilter = filterValue;
    this.dataSource.filter = filterValue.trim().toLowerCase();
    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  clearFilter(): void {
    this.applyFilter('');
  }

  getWorkflows(): void {
    this.workflowStore.loadWorkflows();
  }

  deleteWorkflow(workflow: Workflow): void {
    this.commonDialogService
      .deleteConfirmtionDialog(`${this.translationService.getValue('ARE_YOU_SURE_YOU_WANT_TO_DELETE')} ${workflow.name}`)
      .subscribe((flag: boolean) => {
        if (flag) {
          this.workflowStore.deleteWorkflowById(workflow.id ?? '');
        }
      });
  }

  viewVisualWorkflow(workflow: Workflow): void {
    this.workflowService.getvisualWorkflow(workflow.id ?? '').subscribe({
      next: (data: VisualWorkflowInstance) => {
        const screenWidth = window.innerWidth;
        const dialogWidth = screenWidth < 768 ? '95vw' : '90vw';

        const dialogRef = this.dialog.open(WorkflowGraphComponent, {
          maxWidth: dialogWidth,
          data: { ...data },
        });
      },
      error: (error) => {
        console.error('Error loading workflow:', error);
      }
    });
  }

  ngOnDestroy(): void {
    this.workflowStore.isLoading() === false;
    this.workflowStore.setCurrentStep(0);
    this.workflowStore.commonError === null;
  }

}
