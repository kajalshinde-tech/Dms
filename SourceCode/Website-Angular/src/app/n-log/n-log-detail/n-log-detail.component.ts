import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, RouterModule } from '@angular/router';
import { NLog } from '@core/domain-classes/n-log';
import { TranslateModule } from '@ngx-translate/core';
import { UTCToLocalTime } from '@shared/pipes/utc-to-localtime.pipe';
import { BaseComponent } from '../../base.component';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatTooltipModule } from '@angular/material/tooltip';
import { NgClass } from '@angular/common';

@Component({
  selector: 'app-n-log-detail',
  templateUrl: './n-log-detail.component.html',
  styleUrls: ['./n-log-detail.component.scss'],
  standalone: true,
  imports: [
    TranslateModule,
    UTCToLocalTime,
    RouterModule,
    MatButtonModule,
    MatCardModule,
    MatIconModule,
    MatTooltipModule,
    NgClass
  ]
})
export class NLogDetailComponent extends BaseComponent implements OnInit {
  log: NLog;
  constructor(private activeRoute: ActivatedRoute) {
    super();
  }

  ngOnInit(): void {
    this.sub$.sink = this.activeRoute.data.subscribe(
      (data: any) => {
        if (data.log) {
          this.log = data.log;
        }
      });
  }

  getLevelPillClass(level: string | undefined): string {
    switch (level?.toLowerCase()) {
      case 'fatal':
      case 'error':
        return 'status-pill-danger';
      case 'warn':
      case 'warning':
        return 'status-pill-warning';
      case 'info':
        return 'status-pill-info';
      default:
        return 'status-pill-default';
    }
  }
}
