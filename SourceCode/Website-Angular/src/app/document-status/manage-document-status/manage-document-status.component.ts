import { Component, Inject, inject, OnInit } from '@angular/core';
import {
  FormGroup,
  FormBuilder,
  Validators,
  ReactiveFormsModule,
} from '@angular/forms';
import {
  MAT_DIALOG_DATA,
  MatDialogModule,
  MatDialogRef,
} from '@angular/material/dialog';
import { DocumentStatusService } from '../document-status.service';

import { ToastrService } from '@core/services/toastr-service';
import { DocumentStatus } from '../document-status';
import { TranslateModule } from '@ngx-translate/core';
import { TranslationService } from '@core/services/translation.service';
import { ColorPickerDirective } from 'ngx-color-picker';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-manage-document-status',
  imports: [
    ReactiveFormsModule,
    MatDialogModule,
    TranslateModule,
    ColorPickerDirective,
    MatIconModule,
    MatButtonModule,
    MatCardModule,
    MatTooltipModule
  ],
  templateUrl: './manage-document-status.component.html',
  styleUrl: './manage-document-status.component.scss'
})
export class ManageDocumentStatusComponent implements OnInit {
  public isLoading: boolean = false;
  isEditMode: boolean = false;
  documentStatusForm: FormGroup;
  colorCode: string = '#059669'; // default vibrant color

  presetColors: string[] = [
    '#059669',
    '#2563eb',
    '#7c3aed',
    '#d97706',
    '#dc2626',
    '#0891b2',
    '#4f46e5',
    '#db2777',
    '#0d9488',
    '#ea580c',
    '#475569'
  ];

  public dialogRef = inject(MatDialogRef<ManageDocumentStatusComponent>);
  public documentStatusService = inject(DocumentStatusService);
  private toastrService = inject(ToastrService);
  private translationService = inject(TranslationService);
  private fb = inject(FormBuilder);

  constructor(@Inject(MAT_DIALOG_DATA) public data: DocumentStatus) { }

  ngOnInit(): void {
    this.isEditMode = !!this.data;
    this.createDocumentStatusForm();
  }

  createDocumentStatusForm(): void {
    this.colorCode = this.data?.colorCode || '#059669';
    this.documentStatusForm = this.fb.group({
      name: [
        this.data?.name ?? '',
        [Validators.required],
      ],
      description: [this.data?.description ?? '', Validators.required],
    });
  }

  selectPresetColor(color: string): void {
    this.colorCode = color;
  }

  saveDocumentStatus(): void {
    if (!this.documentStatusForm.valid) {
      this.documentStatusForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;

    if (this.data) {
      const id = this.data.id;
      const documentStatus = {
        ...this.documentStatusForm.value,
        id: id,
        colorCode: this.colorCode,
      };
      this.documentStatusService.updateDocumentStatus(documentStatus).subscribe({
        next: (c) => {
          this.toastrService.success(this.translationService.getValue('DOCUMENT_STATUS_UPDATED_SUCCESSFULLY'));
          this.dialogRef.close(c);
          this.isLoading = false;
        },
        error: () => {
          this.isLoading = false;
        },
      });
    } else {
      const documentStatus = {
        ...this.documentStatusForm.value,
        colorCode: this.colorCode,
      };
      this.documentStatusService.addDocumentStatus(documentStatus).subscribe({
        next: (c) => {
          this.toastrService.success(this.translationService.getValue('DOCUMENT_STATUS_CREATED_SUCCESSFULLY'));
          this.dialogRef.close(c);
          this.isLoading = false;
        },
        error: () => {
          this.isLoading = false;
        },
      });
    }
  }

  closeDialog() {
    this.dialogRef.close();
  }
}
