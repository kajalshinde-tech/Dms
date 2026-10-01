import { Component, inject, OnInit, ViewChild, Renderer2 } from '@angular/core';
import { CalenderReminderDto } from '@core/domain-classes/calender-reminder';
import { forkJoin } from 'rxjs';
import { DashboradService } from '../dashboard.service';
import { CalendarOptions } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction';
import { FullCalendarComponent } from '@fullcalendar/angular';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { ReminderDetailComponent } from '@shared/reminder-detail/reminder-detail.component';
import { TranslateModule } from '@ngx-translate/core';
import { CalenderViewModule } from './calender-view.module';
import { MatCardModule } from '@angular/material/card';

import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-calender-view',
  templateUrl: './calender-view.component.html',
  styleUrls: ['./calender-view.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatDialogModule,
    TranslateModule,
    CalenderViewModule,
    MatCardModule,
    MatIconModule,
    MatButtonModule,
    MatTooltipModule
  ]
})
export class CalenderViewComponent implements OnInit {
  @ViewChild('calendar') calendarComponent: FullCalendarComponent;
  events: any[] = [];
  upcomingEvents: any[] = [];
  renderer = inject(Renderer2);

  calendarOptions: CalendarOptions = {
    initialView: 'dayGridMonth',
    plugins: [dayGridPlugin, interactionPlugin],
    dateClick: (arg) => this.handleDateClick(arg),
    datesSet: (arg) => this.handleDatesSet(arg),
    eventClick: (info) => this.handleEventClick(info),
  };

  dashboardService = inject(DashboradService);
  dialog = inject(MatDialog);

  ngOnInit(): void {
    const currentDate = new Date();
  }

  handleDateClick(arg: any) { }

  handleDatesSet(arg: any) {
    const currentDate = this.calendarComponent
      ?.getApi()
      .getCurrentData().currentDate;
    this.gerReminders(currentDate.getMonth() + 1, currentDate.getFullYear());
  }

  gerReminders(month: number, year: number) {
    this.events = [];
    this.upcomingEvents = [];
    const dailyReminders = this.dashboardService.getDailyReminders(month, year);
    const weeklyReminders = this.dashboardService.getWeeklyReminders(
      month,
      year
    );
    const monthlyReminders = this.dashboardService.getMonthlyReminders(
      month,
      year
    );
    const quarterlyReminders = this.dashboardService.getQuarterlyReminders(
      month,
      year
    );
    const halfYearlyReminders = this.dashboardService.getHalfYearlyReminders(
      month,
      year
    );
    const yearlyReminders = this.dashboardService.getYearlyReminders(
      month,
      year
    );
    const oneTimeReminders = this.dashboardService.getOneTimeReminders(
      month,
      year
    );

    const allEvents$ = [
      dailyReminders,
      weeklyReminders,
      monthlyReminders,
      quarterlyReminders,
      halfYearlyReminders,
      yearlyReminders,
      oneTimeReminders,
    ];

    forkJoin(allEvents$).subscribe((results) => {
      this.addEvent(results[0] as CalenderReminderDto[]);
      this.addEvent(results[1] as CalenderReminderDto[]);
      this.addEvent(results[2] as CalenderReminderDto[]);
      this.addEvent(results[3] as CalenderReminderDto[]);
      this.addEvent(results[4] as CalenderReminderDto[]);
      this.addEvent(results[5] as CalenderReminderDto[]);
      this.addEvent(results[6] as CalenderReminderDto[]);

      // Sort and slice upcoming 5 reminders
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      this.upcomingEvents = [...this.events]
        .filter((e) => new Date(e.start) >= today)
        .sort((a, b) => new Date(a.start).getTime() - new Date(b.start).getTime())
        .slice(0, 5);
    });
  }

  addEvent(calenderReminder: CalenderReminderDto[]) {
    const event = calenderReminder.map((c) => {
      return {
        title: c.title,
        start: new Date(c.start.toString()),
        end: new Date(c.end.toString()),
        extendedProps: {
          remiderId: c?.remiderId,
          description: c?.title, // Tooltip content
        },
      };
    });
    this.events = this.events.concat(event);
  }

  handleEventClick(info: any) {
    this.openReminderDetail(info.event?.extendedProps.remiderId);
  }

  openReminderDetail(reminderId: string) {
    if (!reminderId) return;
    const screenWidth = window.innerWidth;
    const dialogWidth = screenWidth < 768 ? '92vw' : '560px';
    this.dialog.open(ReminderDetailComponent, {
      data: reminderId,
      width: dialogWidth,
      maxWidth: '600px',
      panelClass: 'custom-modern-dialog',
    });
  }
}
