import { Component, inject, OnInit } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { RouterModule } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatTableModule } from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';
import { CommonDialogService } from '../../core/common-dialog/common-dialog.service';
import { AllowFileExtensionService } from '../allow-file-extension.service';
import { AllowFileExtension } from '@core/domain-classes/allow-file-extension';
import { BaseComponent } from '../../base.component';
import { ToastrService } from '@core/services/toastr-service';
import { FileTypePipe } from '../../shared/pipes/file-type.pipe';
import { FileType } from '@core/domain-classes/file-type.enum';
import { HasClaimDirective } from '@shared/has-claim.directive';
import { CommonError } from '@core/error-handler/common-error';

import { NgClass } from '@angular/common';

@Component({
  selector: 'app-allow-file-extension-list',
  standalone: true,
  imports: [
    FormsModule,
    TranslateModule,
    RouterModule,
    MatButtonModule,
    ReactiveFormsModule,
    MatIconModule,
    MatCardModule,
    FileTypePipe,
    MatTableModule,
    MatTooltipModule,
    HasClaimDirective,
    NgClass
  ],
  templateUrl: './allow-file-extension-list.component.html',
  styleUrl: './allow-file-extension-list.component.scss'
})
export class AllowFileExtensionListComponent extends BaseComponent implements OnInit {

  allowFileExtensions: AllowFileExtension[] = [];
  displayedColumns: string[] = ['action', 'type', 'extension'];

  private allowFileExtensionService = inject(AllowFileExtensionService);
  private commonDialogService = inject(CommonDialogService);
  private toastrService = inject(ToastrService);

  ngOnInit(): void {
    this.getAllowFileExtensions();
  }

  getAllowFileExtensions() {
    this.sub$.sink = this.allowFileExtensionService.getAllowFileExtensions()
      .subscribe((result: AllowFileExtension[] | CommonError) => {
        if (Array.isArray(result)) {
          this.allowFileExtensions = result;
        } else {
          this.toastrService.error(this.translationService.getValue('ERROR_LOADING_FILE_EXTENSIONS'));
        }
      });
  }

  getSplitExtensions(extensionStr: string | undefined): string[] {
    if (!extensionStr) return [];
    return extensionStr.split(',').map(ext => ext.trim()).filter(Boolean);
  }

  getTypeIcon(type: number): string {
    switch (type) {
      case FileType.Office: return 'description';
      case FileType.Pdf: return 'picture_as_pdf';
      case FileType.Image: return 'image';
      case FileType.Text: return 'text_snippet';
      case FileType.Audio: return 'audiotrack';
      case FileType.Video: return 'videocam';
      case FileType.CSV: return 'table_view';
      case FileType.Json: return 'data_object';
      default: return 'folder_zip';
    }
  }

  getTypeClass(type: number): string {
    switch (type) {
      case FileType.Office: return 'badge-office';
      case FileType.Pdf: return 'badge-pdf';
      case FileType.Image: return 'badge-image';
      case FileType.Text: return 'badge-text';
      case FileType.Audio: return 'badge-audio';
      case FileType.Video: return 'badge-video';
      case FileType.CSV: return 'badge-csv';
      case FileType.Json: return 'badge-json';
      default: return 'badge-other';
    }
  }

  deleteAllowFileExtension(setting: AllowFileExtension) {
    this.sub$.sink = this.commonDialogService
      .deleteConfirmtionDialog(`${this.translationService.getValue('ARE_YOU_SURE_YOU_WANT_TO_DELETE')} ${FileType[setting.fileType]}`)
      .subscribe((isTrue: boolean) => {
        if (isTrue) {
          this.sub$.sink = this.allowFileExtensionService.deleteAllowFileExtension(setting.id ?? '').subscribe(() => {
            this.toastrService.success(this.translationService.getValue('ALLOW_FILE_EXTENSION_DELETED_SUCCESSFULLY'));
            this.getAllowFileExtensions();
          });
        }
      });
  }
}
