import { Component, effect, inject, OnInit, ViewChild } from '@angular/core';
import { DashboradService } from '../dashboard.service';
import { WorkflowInstanceService } from '../../workflows/workflow-instance.service';
import { MatDialog } from '@angular/material/dialog';
import { WorkflowInstanceData } from '@core/domain-classes/workflow-instance-data';
import { CurrentWorkflowTransition } from '@core/domain-classes/current-workflow-transition';
import { NextTransition } from '@core/domain-classes/next-transition';
import { VisualWorkflowInstance } from '@core/domain-classes/visual-workflow-instance';
import { DocumentView } from '@core/domain-classes/document-view';
import { CommonDialogService } from '@core/common-dialog/common-dialog.service';
import { CommonService } from '@core/services/common.service';
import { ToastrService } from '@core/services/toastr-service';
import { OverlayPanel } from '@shared/overlay-panel/overlay-panel.service';
import { WorkflowInstanceStatus } from '../../core/domain-classes/workflow-instance-status.enum';
import { MatTooltipModule, TooltipPosition } from '@angular/material/tooltip';
import { SignalrService } from '@core/services/signalr.service';
import { BaseComponent } from '../../base.component';
import { PerformTransitionComponent } from '../../workflows/perform-transition/perform-transition.component';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { MatPaginator, PageEvent } from '@angular/material/paginator';
import { HasClaimDirective } from '@shared/has-claim.directive';
import { NGX_ECHARTS_CONFIG, NgxEchartsModule } from 'ngx-echarts';
import { TranslateModule } from '@ngx-translate/core';
import { MatButtonModule } from '@angular/material/button';
import { CommonModule, NgClass } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { ThemeService } from '@core/services/theme.service';
import { SecurityService } from '@core/security/security.service';

@Component({
  selector: 'app-document-by-category-chart',
  templateUrl: './document-by-category-chart.component.html',
  styleUrls: ['./document-by-category-chart.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
    MatPaginator,
    MatTableModule,
    HasClaimDirective,
    MatTooltipModule,
    NgxEchartsModule,
    TranslateModule,
    MatButtonModule,
    NgClass,
    MatIconModule,
    MatCardModule,
    MatProgressSpinnerModule
  ],
  providers: [
    {
      provide: NGX_ECHARTS_CONFIG,
      useValue: {
        echarts: () => import('echarts'),
      },
    }
  ],
})
export class DocumentByCategoryChartComponent
  extends BaseComponent
  implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  workflowInstances: WorkflowInstanceData[] = [];
  WorkflowInstanceStatus = WorkflowInstanceStatus;
  isLoadingResults = false;
  hasWorkflowClaim: boolean = false;
  totalCategoriesCount: number = 0;
  currentPrimaryColor: string = '#059669';

  displayedColumns: string[] = [
    'detail',
    'workflowname',
    'documentname',
    'transition',
  ];
  dataSource: MatTableDataSource<any>;
  isLoading: boolean = true;
  private dashboardService = inject(DashboradService);
  private workflowInstanceService = inject(WorkflowInstanceService);
  private signalrService = inject(SignalrService);
  private dialog = inject(MatDialog);
  private commonDialogService = inject(CommonDialogService);
  private commonService = inject(CommonService);
  private toastrService = inject(ToastrService);
  public overlay = inject(OverlayPanel);
  private themeService = inject(ThemeService);
  private securityService = inject(SecurityService);
  positionOptions: TooltipPosition[] = ['below', 'above', 'left', 'right'];

  echartsInstance: any = null;

  barChartOptions: any = {
    title: {
      text: '',
      left: 'center',
    },
    tooltip: {
      trigger: 'axis',
      backgroundColor: '#1e293b',
      borderColor: '#334155',
      textStyle: {
        color: '#f8fafc',
        fontSize: 12,
        fontWeight: 500,
      },
      axisPointer: {
        type: 'shadow',
        shadowStyle: {
          color: 'rgba(16, 185, 129, 0.08)',
        },
      },
      formatter: (params: any) => {
        if (!params || !params.length) return '';
        const item = params[0];
        return `
          <div style="padding: 4px 6px;">
            <div style="font-size: 11px; color: #94a3b8; margin-bottom: 2px;">Category</div>
            <div style="font-weight: 600; font-size: 13px; color: #ffffff; margin-bottom: 6px;">${item.name}</div>
            <div style="display: flex; align-items: center; gap: 6px; font-size: 12px; color: #34d399;">
              <span style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#10b981;"></span>
              <span>${item.value} Documents</span>
            </div>
          </div>
        `;
      },
    },
    grid: {
      left: '2%',
      right: '2%',
      bottom: '10%',
      top: '8%',
      containLabel: true,
    },
    xAxis: {
      type: 'category',
      data: [],
      axisTick: {
        alignWithLabel: true,
      },
      axisLine: {
        lineStyle: {
          color: '#e2e8f0',
        },
      },
      axisLabel: {
        interval: 0,
        rotate: 25,
        color: '#64748b',
        fontSize: 11,
        formatter: (value: string) => {
          return value && value.length > 14 ? value.substring(0, 12) + '...' : value;
        },
      },
    },
    yAxis: {
      type: 'value',
      min: 0,
      minInterval: 1,
      splitLine: {
        lineStyle: {
          type: 'dashed',
          color: '#f1f5f9',
        },
      },
      axisLabel: {
        color: '#64748b',
        fontSize: 11,
      },
    },
    series: [
      {
        name: 'Documents',
        type: 'bar',
        barWidth: '42%',
        data: [],
        itemStyle: {
          borderRadius: [6, 6, 0, 0],
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: '#10b981' },
              { offset: 1, color: '#059669' },
            ],
          },
        },
      },
    ],
  };

  constructor() {
    super();
    effect(() => {
      const theme = this.themeService.currentTheme();
      if (theme && theme.primaryColor) {
        this.currentPrimaryColor = theme.primaryColor;
        this.applyDynamicPrimaryColor(theme.primaryColor);
      }
    });
  }

  ngOnInit(): void {
    this.hasWorkflowClaim = this.securityService.hasClaim('CURRENT_WORKFLOW');
    this.dataSource = new MatTableDataSource(this.workflowInstances);
    this.dataSource.paginator = this.paginator;
    this.getDocumentCategoryChartData();
    this.getWorkflows();
    this.sub$.sink = this.signalrService.workItemNotification$.subscribe(() => {
      this.getWorkflows();
    });
  }

  ngAfterViewInit() {
    if (this.paginator && this.dataSource) {
      this.dataSource.paginator = this.paginator;
    }
  }

  getDocumentCategoryChartData() {
    this.dashboardService.getDocumentByCategory().subscribe({
      next: (data) => {
        this.isLoading = false;
        this.totalCategoriesCount = data.length;
        const categories = data.map((c) => c.categoryName);
        const values = data.map((c) => c.documentCount);
        const primaryColor = this.currentPrimaryColor || getComputedStyle(document.documentElement).getPropertyValue('--app-primary-color').trim() || '#059669';
        const darkPrimary = this.themeService.darkenColor(primaryColor, 15);

        this.barChartOptions = {
          ...this.barChartOptions,
          xAxis: {
            ...this.barChartOptions.xAxis,
            data: categories,
          },
          series: [
            {
              ...this.barChartOptions.series[0],
              data: values,
              itemStyle: {
                borderRadius: [6, 6, 0, 0],
                color: {
                  type: 'linear',
                  x: 0,
                  y: 0,
                  x2: 0,
                  y2: 1,
                  colorStops: [
                    { offset: 0, color: primaryColor },
                    { offset: 1, color: darkPrimary },
                  ],
                },
              },
            },
          ],
        };
      },
      error: () => {
        this.isLoading = false;
      },
    });
  }

  applyDynamicPrimaryColor(primaryColor: string) {
    if (!this.barChartOptions || !this.barChartOptions.series || !this.barChartOptions.series[0]) return;
    const darkPrimary = this.themeService.darkenColor(primaryColor, 15);
    this.barChartOptions = {
      ...this.barChartOptions,
      series: [
        {
          ...this.barChartOptions.series[0],
          itemStyle: {
            borderRadius: [6, 6, 0, 0],
            color: {
              type: 'linear',
              x: 0,
              y: 0,
              x2: 0,
              y2: 1,
              colorStops: [
                { offset: 0, color: primaryColor },
                { offset: 1, color: darkPrimary },
              ],
            },
          },
        },
      ],
    };
    if (this.echartsInstance) {
      this.echartsInstance.setOption(this.barChartOptions);
    }
  }

  updateChartData(newData: any) {
    this.barChartOptions = {
      ...this.barChartOptions,
      series: [
        {
          ...this.barChartOptions.series[0],
          data: newData, // Updated series data
        },
      ],
    };
  }

  onChartInit(ec: any) {
    this.echartsInstance = ec;
  }

  getWorkflows(): void {
    this.sub$.sink = this.workflowInstanceService
      .getCurrentWorkflowInstances()
      .subscribe({
        next: (data: WorkflowInstanceData[]) => {
          this.workflowInstances = data;
          this.dataSource.data = data;
        },
        error: (error) => { },
      });
  }

  performTransition(
    transition: CurrentWorkflowTransition,
    workflowInstance: WorkflowInstanceData
  ): void {
    if (transition.isUploadDocumentVersion) {
      const nextTransition: NextTransition = {
        workflowInstanceId: workflowInstance.workflowInstanceId,
        transitionId: transition.id,
        documentId: workflowInstance.documentId,
        workflowStepInstanceId: workflowInstance.workflowStepInstanceId,
        comment: '',
        isUploadDocumentVersion: transition.isUploadDocumentVersion,
        isSignatureRequired: transition.isSignatureRequired,
        isUserSignRequired: transition.isUserSignRequired,
        transitionName: transition.name,
      };
      const screenWidth = window.innerWidth;
      const dialogWidth = screenWidth < 768 ? '80vw' : '60vw';
      const dialogRef = this.dialog.open(PerformTransitionComponent, {
        width: dialogWidth,
        data: Object.assign({}, nextTransition),
      });

      dialogRef.afterClosed().subscribe((result: boolean) => {
        if (result) {
          this.getWorkflows();
        }
      });
      return;
    }

    if (!transition.isSignatureRequired) {
      this.performContinueWorkflow(transition, workflowInstance);
    } else if (
      !transition.isSignatureRequired &&
      !transition.isUserSignRequired
    ) {
      this.performContinueWorkflow(transition, workflowInstance);
    } else {
      this.commonService
        .checkDocumentIsSignedByUser(workflowInstance.documentId)
        .subscribe({
          next: (flag: boolean) => {
            if (!flag) {
              const nextTransition: NextTransition = {
                workflowInstanceId: workflowInstance.workflowInstanceId,
                transitionId: transition.id,
                workflowStepInstanceId: workflowInstance.workflowStepInstanceId,
                comment: '',
                isUploadDocumentVersion: false,
                isSignatureRequired: transition.isSignatureRequired,
                isUserSignRequired: transition.isUserSignRequired,
                transitionName: transition.name,
                documentId: workflowInstance.documentId,
              };
              const dialogRef = this.dialog.open(PerformTransitionComponent, {
                data: Object.assign({}, nextTransition),
              });

              dialogRef.afterClosed().subscribe((result: boolean) => {
                if (result) {
                  this.getWorkflows();
                }
              });
            } else {
              this.performContinueWorkflow(transition, workflowInstance);
            }
          },
          error: (error) => { },
        });
    }
  }

  performContinueWorkflow(
    transition: CurrentWorkflowTransition,
    workflowInstance: WorkflowInstanceData
  ): void {
    this.commonDialogService
      .deleteConfirmWithCommentDialog(
        `${this.translationService.getValue(
          'ARE_YOU_SURE_YOU_WANT_TO_PROCEED_WITH_THIS_WORKFLOW_TRANSITION'
        )}:: ${transition.name} ?`
      )
      .subscribe((commentFlag: any) => {
        if (commentFlag.flag) {
          const nextTransition: NextTransition = {
            workflowInstanceId: workflowInstance.workflowInstanceId,
            transitionId: transition.id,
            workflowStepInstanceId: workflowInstance.workflowStepInstanceId,
            comment: commentFlag.comment,
          };
          this.workflowInstanceService
            .performNextTransition(nextTransition)
            .subscribe({
              next: (data: boolean) => {
                if (data) {
                  this.toastrService.success(
                    `${transition.name} ${this.translationService.getValue(
                      'HAS_BEEN_SUCCESSFULLY_COMPLETED'
                    )}`
                  );
                  this.getWorkflows();
                }
              },
              error: (error) => { },
            });
        }
      });
  }

  viewVisualWorkflow(workflowInstance: WorkflowInstanceData): void {
    this.workflowInstanceService
      .getvisualWorkflowInstance(workflowInstance.workflowInstanceId)
      .subscribe({
        next: async (data: VisualWorkflowInstance) => {
          this.isLoadingResults = true;
          try {
            const { VisualWorkflowGraphComponent } = await import(
              '../../workflows/visual-workflow-graph/visual-workflow-graph.component'
            );
            const dialogRef = this.dialog.open(VisualWorkflowGraphComponent, {
              width: '1100px',
              maxWidth: '95vw',
              maxHeight: '92vh',
              autoFocus: false,
              data: Object.assign({}, data),
            });
          }
          finally {
            this.isLoadingResults = false;
          }
        },
        error: (error) => { },
      });
  }

  async onDocumentView(document: WorkflowInstanceData) {
    this.isLoadingResults = true;
    try {
      const urls = document.documentUrl.split('.');
      const extension = urls[1];
      const documentView: DocumentView = {
        documentId: document.documentId,
        name: document.documentName,
        extension: extension,
        isVersion: false,
        isFromPublicPreview: false,
        isPreviewDownloadEnabled: false,
        isFileRequestDocument: false,
        isSignatureExists: false,
        documentNumber: document.documentNumber,
      };
      const { BasePreviewComponent } = await import(
        '../../shared/base-preview/base-preview.component'
      );
      this.overlay.open(BasePreviewComponent, {
        position: 'center',
        origin: 'global',
        panelClass: ['file-preview-overlay-container', 'white-background'],
        data: documentView,
      });
    }
    finally {
      this.isLoadingResults = false;
    }
  }

  onPageChanged(event: PageEvent): void {
    const pageIndex = event.pageIndex;
    const pageSize = event.pageSize;
  }
}
