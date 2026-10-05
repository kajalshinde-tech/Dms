import { Component, inject, OnInit, ViewChild, AfterViewInit } from '@angular/core';
import { AIPromptTemplate } from './ai-prompt-template';
import { AIPromptTemplateService } from './ai-prompt-template.service';
import { ToastrService } from '@core/services/toastr-service';
import { TranslationService } from '@core/services/translation.service';
import { Router, RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { MatIconModule } from '@angular/material/icon';
import { CommonDialogService } from '@core/common-dialog/common-dialog.service';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatSort, MatSortModule } from '@angular/material/sort';
import { HasClaimDirective } from '@shared/has-claim.directive';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-template-openai-list',
  imports: [
    CommonModule,
    RouterModule,
    TranslateModule,
    MatTableModule,
    MatIconModule,
    MatPaginatorModule,
    MatSortModule,
    HasClaimDirective,
    MatCardModule,
    MatButtonModule,
    MatTooltipModule,
    FormsModule
  ],
  templateUrl: './template-openai-list.component.html',
  styleUrl: './template-openai-list.component.scss'
})
export class TemplateOpenaiListComponent implements OnInit, AfterViewInit {
  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;

  dataSource = new MatTableDataSource<AIPromptTemplate>([]);
  searchValue: string = '';
  displayedColumns: string[] = ['action', 'name', 'description', 'promptInput'];
  isLoadingResults = false;

  private aIPromptTemplateService = inject(AIPromptTemplateService);
  private toastrService = inject(ToastrService);
  private translationService = inject(TranslationService);
  private commonDialogService = inject(CommonDialogService);
  private router = inject(Router);

  constructor() {
    this.dataSource.filterPredicate = (data: AIPromptTemplate, filter: string) => {
      const nameMatch = data.name?.toLowerCase().includes(filter) ?? false;
      const descMatch = data.description?.toLowerCase().includes(filter) ?? false;
      const promptMatch = data.promptInput?.toLowerCase().includes(filter) ?? false;
      return nameMatch || descMatch || promptMatch;
    };
  }

  ngOnInit(): void {
    this.getAiPromtTemplateSettings();
  }

  ngAfterViewInit(): void {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  getAiPromtTemplateSettings(): void {
    this.isLoadingResults = true;
    this.aIPromptTemplateService.getAIPromptTemplates().subscribe({
      next: (data: AIPromptTemplate[]) => {
        this.isLoadingResults = false;
        this.dataSource.data = data || [];
        if (this.paginator) {
          this.dataSource.paginator = this.paginator;
        }
        if (this.sort) {
          this.dataSource.sort = this.sort;
        }
      },
      error: () => {
        this.isLoadingResults = false;
      }
    });
  }

  applyFilter(event: Event | string): void {
    const filterValue = typeof event === 'string' ? event : (event.target as HTMLInputElement).value;
    this.searchValue = filterValue;
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }

  clearSearch(): void {
    this.searchValue = '';
    this.dataSource.filter = '';
  }

  onAiPromptTemplates(): void {
    this.router.navigate([`/aiprompttemplate/new`]);
  }

  editAiPromptTemplates(aiPromptTemplates: AIPromptTemplate) {
    this.router.navigate([`/aiprompttemplate/${aiPromptTemplates.id}`]);
  }

  deleteAiPromptTemplates(aiPromptTemplates: AIPromptTemplate) {
    this.commonDialogService
      .deleteConfirmtionDialog(
        `${this.translationService.getValue(
          'ARE_YOU_SURE_YOU_WANT_TO_DELETE'
        )} ${aiPromptTemplates.name}`
      )
      .subscribe((isTrue: boolean) => {
        if (isTrue) {
          this.aIPromptTemplateService.deleteAIPromptTemplate(aiPromptTemplates.id ?? '').subscribe({
            next: (data: boolean) => {
              if (data) {
                this.toastrService.success(
                  this.translationService.getValue(
                    'AI_PROMPT_TEMPLATE_DELETE_SUCCESSFULLY'
                  )
                );
                this.getAiPromtTemplateSettings();
              }
            }
          });
        }
      });
  }
}
