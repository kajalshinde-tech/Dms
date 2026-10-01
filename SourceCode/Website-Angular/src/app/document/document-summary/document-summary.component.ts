import { Component, Inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MatDialogModule, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { TranslateModule } from '@ngx-translate/core';
import { MatCardModule } from '@angular/material/card';
import { MatTooltipModule } from '@angular/material/tooltip';
import { ToastrService } from '@core/services/toastr-service';
import { TranslationService } from '@core/services/translation.service';

@Component({
  selector: 'app-document-summary',
  imports: [
    MatDialogModule,
    FormsModule,
    MatIconModule,
    MatButtonModule,
    TranslateModule,
    MatCardModule,
    MatTooltipModule
  ],
  templateUrl: './document-summary.component.html',
  styleUrl: './document-summary.component.scss'
})
export class DocumentSummaryComponent {
  documentSummary: string = '';
  isCopied: boolean = false;

  constructor(
    public dialogRef: MatDialogRef<DocumentSummaryComponent>,
    @Inject(MAT_DIALOG_DATA) public data: string,
    private toastrService: ToastrService,
    private translationService: TranslationService
  ) {
    this.documentSummary = data;
  }

  onDocumentCancel() {
    this.dialogRef.close(false);
  }

  copyToClipboard() {
    if (!this.documentSummary) return;
    navigator.clipboard.writeText(this.documentSummary).then(() => {
      this.isCopied = true;
      this.toastrService.success(this.translationService.getValue('COPIED_TO_CLIPBOARD') || 'Summary copied to clipboard!');
      setTimeout(() => {
        this.isCopied = false;
      }, 2000);
    });
  }
}
