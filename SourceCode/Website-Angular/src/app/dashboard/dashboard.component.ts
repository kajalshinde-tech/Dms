import { Component, inject, OnInit, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';
import { BaseComponent } from '../base.component';
import { DashboradService } from './dashboard.service';
import { WorkflowInstanceService } from '../workflows/workflow-instance.service';
import { SignalrService } from '@core/services/signalr.service';
import { DocumentByCategoryChartComponent } from './document-by-category-chart/document-by-category-chart.component';
import { CalenderViewComponent } from './calender-view/calender-view.component';
import { forkJoin } from 'rxjs';
import { CalenderReminderDto } from '@core/domain-classes/calender-reminder';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    TranslateModule,
    MatCardModule,
    MatIconModule,
    MatButtonModule,
    MatTooltipModule,
    DocumentByCategoryChartComponent,
    CalenderViewComponent
  ]
})
export class DashboardComponent extends BaseComponent implements OnInit {
  @ViewChild('chartComponent') chartComponent?: DocumentByCategoryChartComponent;
  @ViewChild('calendarComponent') calendarComponent?: CalenderViewComponent;

  totalDocuments: number = 0;
  totalCategories: number = 0;
  pendingWorkflowsCount: number = 0;
  totalRemindersCount: number = 0;
  isLoadingKpis: boolean = true;
  isRefreshing: boolean = false;

  private dashboardService = inject(DashboradService);
  private workflowInstanceService = inject(WorkflowInstanceService);
  private signalrService = inject(SignalrService);

  constructor() {
    super();
  }

  ngOnInit(): void {
    this.loadKpiData();

    // Live reactive refresh when a workflow item notification arrives via SignalR
    this.sub$.sink = this.signalrService.workItemNotification$.subscribe(() => {
      this.loadWorkflowCount();
    });
  }

  loadKpiData(): void {
    this.isLoadingKpis = true;
    const now = new Date();
    const currentMonth = now.getMonth() + 1;
    const currentYear = now.getFullYear();

    // 1. Fetch Categories & Document Totals
    const docCategories$ = this.dashboardService.getDocumentByCategory();

    // 2. Fetch Pending Assigned Workflows for Current User
    const workflows$ = this.workflowInstanceService.getCurrentWorkflowInstances();

    // 3. Fetch Monthly Reminders for Current Month
    const daily$ = this.dashboardService.getDailyReminders(currentMonth, currentYear);
    const weekly$ = this.dashboardService.getWeeklyReminders(currentMonth, currentYear);
    const monthly$ = this.dashboardService.getMonthlyReminders(currentMonth, currentYear);
    const oneTime$ = this.dashboardService.getOneTimeReminders(currentMonth, currentYear);

    forkJoin({
      categories: docCategories$,
      workflows: workflows$,
      daily: daily$,
      weekly: weekly$,
      monthly: monthly$,
      oneTime: oneTime$,
    }).subscribe({
      next: (res) => {
        // Compute Total Documents and Total Categories
        if (Array.isArray(res.categories)) {
          this.totalCategories = res.categories.length;
          this.totalDocuments = res.categories.reduce((sum, item) => sum + (item.documentCount || 0), 0);
        }

        // Compute Pending Workflows
        if (Array.isArray(res.workflows)) {
          this.pendingWorkflowsCount = res.workflows.length;
        }

        // Compute Total Monthly Reminders
        let reminderCount = 0;
        if (Array.isArray(res.daily)) reminderCount += (res.daily as CalenderReminderDto[]).length;
        if (Array.isArray(res.weekly)) reminderCount += (res.weekly as CalenderReminderDto[]).length;
        if (Array.isArray(res.monthly)) reminderCount += (res.monthly as CalenderReminderDto[]).length;
        if (Array.isArray(res.oneTime)) reminderCount += (res.oneTime as CalenderReminderDto[]).length;
        this.totalRemindersCount = reminderCount;

        this.isLoadingKpis = false;
        this.isRefreshing = false;
      },
      error: () => {
        this.isLoadingKpis = false;
        this.isRefreshing = false;
      }
    });
  }

  loadWorkflowCount(): void {
    this.workflowInstanceService.getCurrentWorkflowInstances().subscribe({
      next: (data) => {
        if (Array.isArray(data)) {
          this.pendingWorkflowsCount = data.length;
        }
      }
    });
  }

  refreshAll(): void {
    this.isRefreshing = true;
    this.loadKpiData();

    if (this.chartComponent) {
      this.chartComponent.getDocumentCategoryChartData();
      this.chartComponent.getWorkflows();
    }

    if (this.calendarComponent) {
      const now = new Date();
      this.calendarComponent.gerReminders(now.getMonth() + 1, now.getFullYear());
    }
  }
}
