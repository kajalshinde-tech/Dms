import { Component, ElementRef, inject, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, FormsModule } from '@angular/forms';
import { OCRContentExtractorService } from './ocr-content-extractor.service';
import { AllowFileExtension } from '@core/domain-classes/allow-file-extension';
import { CommonService } from '@core/services/common.service';
import { validateFile } from '@core/domain-classes/extension-types';
import { ToastrService } from '@core/services/toastr-service';
import { CommonError } from '../core/error-handler/common-error';
import { TranslateModule } from '@ngx-translate/core';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { BaseComponent } from '../base.component';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-ocr-content-extractor',
  imports: [
    FormsModule,
    TranslateModule,
    MatProgressSpinnerModule,
    MatIconModule,
    MatCardModule,
    MatButtonModule,
    MatTooltipModule
  ],
  templateUrl: './ocr-content-extractor.component.html',
  styleUrl: './ocr-content-extractor.component.scss'
})
export class OcrContentExtractorComponent extends BaseComponent implements OnInit {
  documentForm: FormGroup;
  allowFileExtension: AllowFileExtension[] = [];
  extension: string;
  fb = inject(FormBuilder);
  ocrContentExtractorService = inject(OCRContentExtractorService);
  commonService = inject(CommonService);
  toastrService = inject(ToastrService);
  fileData: File | null = null;
  extractedText: string = '';
  isLoading: boolean = false;
  errorMessage: string = '';
  @ViewChild('file') fileInput!: ElementRef;
  mode: string = 'indeterminate';

  ngOnInit(): void {
    this.getAllAllowFileExtension();
  }

  fileExtesionValidation(extension: string): boolean {
    if (!extension) return false;
    const extLower = extension.toLowerCase();
    const commonSupportedExts = [
      'pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'txt',
      'png', 'jpg', 'jpeg', 'tiff', 'bmp', 'gif', 'webp'
    ];
    if (commonSupportedExts.includes(extLower)) {
      return true;
    }
    const allowTypeExtenstion = this.allowFileExtension.find((c) =>
      c.extensions?.find((ext) => ext.toLowerCase() === extLower)
    );
    return allowTypeExtenstion ? true : false;
  }

  getAllAllowFileExtension() {
    this.commonService.getAllowFileExtensions().subscribe();
    this.sub$.sink = this.commonService.allowFileExtension$.subscribe(
      (allowFileExtension: AllowFileExtension[]) => {
        if (allowFileExtension) {
          this.allowFileExtension = allowFileExtension;
        }
      }
    );
  }

  async upload(files: FileList | null | undefined) {
    if (!files || files.length === 0) return;
    if (!(await validateFile(files[0]))) {
      this.toastrService.error(
        this.translationService.getValue(
          'INVALID_EXTENSION_OR_CORRUPT_INVALID_SIGNATURE'
        )
      );
      this.errorMessage = this.translationService.getValue(
        'INVALID_EXTENSION_OR_CORRUPT_INVALID_SIGNATURE'
      );
      return;
    }

    this.extension = files[0].name.split('.').pop() ?? '';
    if (!this.fileExtesionValidation(this.extension)) {
      this.errorMessage = this.translationService.getValue(
        'INVALID_EXTENSION_OR_CORRUPT_INVALID_SIGNATURE'
      );
      return;
    }
    this.fileData = files[0];
    this.errorMessage = "";
  }

  removeSelectedFile() {
    this.fileData = null;
    this.errorMessage = '';
    if (this.fileInput) {
      this.fileInput.nativeElement.value = null;
    }
  }

  extract() {
    if (this.fileData) {
      const maxSize = 10 * 1024 * 1024; // 10MB in bytes
      if (this.fileData.size <= maxSize) {
        this.isLoading = true;
        const ext = "." + this.extension.toLowerCase();
        this.ocrContentExtractorService
          .getDocumentContentByOcr(this.fileData, ext)
          .subscribe({
            next: (res: string | CommonError) => {
              this.isLoading = false;
              this.errorMessage = '';
              if (typeof res === 'string') {
                this.extractedText = res;
                if (res.trim().length > 0) {
                  this.toastrService.success(
                    this.translationService.getValue('OCR_CONTENT_EXTRACTOR_SUCCESS')
                  );
                } else {
                  this.toastrService.info('No readable text found in document.');
                }
              } else {
                this.extractedText = '';
                this.toastrService.error(
                  this.translationService.getValue('OCR_CONTENT_EXTRACTOR_FAILED')
                );
              }
            },
            error: (error: CommonError) => {
              this.errorMessage = '';
              this.isLoading = false;
            }
          });
      } else {
        this.isLoading = false;
        this.toastrService.error(
          this.translationService.getValue('FILE_SIZE_EXCEEDS_LIMIT')
        );
        this.errorMessage = this.translationService.getValue('FILE_SIZE_EXCEEDS_LIMIT');
      }
    }
  }

  copyToClipboard() {
    if (this.extractedText) {
      navigator.clipboard.writeText(this.extractedText).then(() => {
        this.toastrService.success(this.translationService.getValue('COPIED_TO_CLIPBOARD') || 'Copied to clipboard!');
      });
    }
  }

  downloadAsTxt() {
    if (!this.extractedText) return;
    const blob = new Blob([this.extractedText], { type: 'text/plain;charset=utf-8' });
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `ocr-extracted-text-${Date.now()}.txt`;
    link.click();
    window.URL.revokeObjectURL(url);
  }

  clearExtractedText() {
    this.extractedText = '';
  }

  formatBytes(bytes: number, decimals: number = 2): string {
    if (!bytes) return '0 Bytes';
    const k = 1024;
    const dm = decimals < 0 ? 0 : decimals;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
  }
}
