import { Component, inject, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { TableSetting } from '../../../core/domain-classes/table-setting';
import { MatTableSetting } from '../../../core/domain-classes/mat-table-setting';
import { TranslationService } from '../../../core/services/translation.service';
import { ToastrService } from '@core/services/toastr-service';
import { MatIconModule } from '@angular/material/icon';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { Router, RouterModule } from '@angular/router';
import { DocumentStore } from '../document-store';
import { TranslateModule } from '@ngx-translate/core';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-table-settings',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatIconModule,
    MatCheckboxModule,
    RouterModule,
    TranslateModule,
    MatCardModule,
    MatButtonModule,
    MatTooltipModule
  ],
  templateUrl: './table-settings.component.html',
  styleUrl: './table-settings.component.scss'
})
export class TableSettingsComponent implements OnInit {
  tableSettingsForm: FormGroup;
  screenName: string = 'documents';
  documentStore = inject(DocumentStore);
  matTableSetting: MatTableSetting | null = this.documentStore.matTableSetting();
  fb = inject(FormBuilder);
  toastrService = inject(ToastrService);
  translationService = inject(TranslationService);
  router = inject(Router);

  ngOnInit(): void {
    this.createTableSettingsForm();
    if (this.matTableSetting) {
      this.tableSettingsForm.patchValue({
        id: this.matTableSetting.id,
        screenName: this.matTableSetting.screenName
      });
      this.matTableSetting.settings.forEach(setting => {
        this.settingsArray.push(this.createSettingGroup(setting));
      });
    }
  }

  createTableSettingsForm() {
    this.tableSettingsForm = this.fb.group({
      id: [0],
      screenName: [this.screenName],
      settingsArray: this.fb.array([])
    });
  }

  get settingsArray(): FormArray {
    return this.tableSettingsForm.get('settingsArray') as FormArray;
  }

  createSettingGroup(setting?: TableSetting): FormGroup {
    return this.fb.group({
      key: [setting ? setting.key : ''],
      header: [setting ? setting.header : ''],
      width: [setting ? setting.width : 100, Validators.required],
      type: [setting ? setting.type : 'text'],
      isVisible: [setting ? setting.isVisible : true],
      orderNumber: [setting ? setting.orderNumber : 0, Validators.required],
      allowSort: [setting ? setting.allowSort : true]
    });
  }

  saveTableSettings() {
    if (this.tableSettingsForm.invalid) {
      this.tableSettingsForm.markAllAsTouched();
      return;
    }

    const formValue = this.tableSettingsForm.value;
    const matTableSetting: MatTableSetting = {
      id: formValue.id,
      screenName: formValue.screenName,
      settings: formValue.settingsArray
    };

    this.documentStore.saveTableSettings(matTableSetting);
    this.router.navigate(['/documents']);
  }

  onSeetingsClose() {
    this.router.navigate(['/documents']);
  }
}
