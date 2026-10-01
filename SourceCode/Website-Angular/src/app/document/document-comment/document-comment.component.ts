import { Component, Inject, OnInit } from '@angular/core';
import { ReactiveFormsModule, UntypedFormBuilder, UntypedFormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { CommonDialogService } from '@core/common-dialog/common-dialog.service';
import { DocumentComment } from '@core/domain-classes/document-comment';
import { BaseComponent } from '../../base.component';
import { DocumentCommentService } from './document-comment.service';
import { HasClaimDirective } from '@shared/has-claim.directive';
import { TranslateModule } from '@ngx-translate/core';
import { UTCToLocalTime } from '@shared/pipes/utc-to-localtime.pipe';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-document-comment',
  templateUrl: './document-comment.component.html',
  styleUrls: ['./document-comment.component.scss'],
  standalone: true,
  imports: [
    HasClaimDirective,
    ReactiveFormsModule,
    MatDialogModule,
    TranslateModule,
    UTCToLocalTime,
    MatIconModule,
    MatCardModule,
    MatButtonModule,
    MatTooltipModule
  ]
})
export class DocumentCommentComponent extends BaseComponent implements OnInit {
  commentForm: UntypedFormGroup;
  documentComments: DocumentComment[] = [];
  isCommentUpdate: boolean = false;

  constructor(
    private fb: UntypedFormBuilder,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private documentCommentService: DocumentCommentService,
    private dialogRef: MatDialogRef<DocumentCommentComponent>,
    private commonDialogService: CommonDialogService
  ) {
    super();
  }

  ngOnInit(): void {
    this.createForm();
    this.getDocumentComment();
  }

  closeDialog() {
    if (this.isCommentUpdate) {
      this.dialogRef.close('loaded');
      return;
    }
    this.dialogRef.close();
  }

  createForm() {
    this.commentForm = this.fb.group({
      comment: ['', [Validators.required]]
    });
  }

  getDocumentComment() {
    this.sub$.sink = this.documentCommentService.getDocumentComment(this.data.id)
      .subscribe((c: DocumentComment[]) => {
        this.documentComments = c || [];
      });
  }

  patchComment(comment: string) {
    this.commentForm.patchValue({
      comment: comment
    });
  }

  getInitials(name: string): string {
    if (!name) return 'U';
    const parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  addComment() {
    if (this.commentForm.invalid) {
      this.commentForm.markAllAsTouched();
      return;
    }
    const documentComment: DocumentComment = {
      documentId: this.data.id,
      comment: this.commentForm.get('comment')?.value
    };
    this.sub$.sink = this.documentCommentService.saveDocumentComment(documentComment)
      .subscribe((c: DocumentComment) => {
        this.patchComment('');
        this.isCommentUpdate = true;
        this.commentForm.markAsUntouched();
        this.getDocumentComment();
      });
  }

  onDelete(id: string) {
    this.sub$.sink = this.commonDialogService
      .deleteConfirmtionDialog(`${this.translationService.getValue('ARE_YOU_SURE_YOU_WANT_TO_DELETE')}?`)
      .subscribe((isTrue: boolean) => {
        if (isTrue) {
          this.sub$.sink = this.documentCommentService.deleteDocumentComment(id)
            .subscribe(() => {
              this.isCommentUpdate = true;
              this.getDocumentComment();
            });
        }
      });
  }
}
