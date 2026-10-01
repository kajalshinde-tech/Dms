import { Directive, ElementRef, Input, OnInit } from '@angular/core';

@Directive({
  selector: '[appDocumentOperationColor]',
  standalone: true,
})
export class DocumentOperationColorDirective implements OnInit {
  @Input() appDocumentOperationColor!: string;

  constructor(private el: ElementRef) { }

  ngOnInit() {
    this.setColor(this.appDocumentOperationColor);
  }

  private setColor(operationName: string) {
    const el = this.el.nativeElement;
    const op = operationName?.toLowerCase() || '';

    el.style.display = 'inline-flex';
    el.style.alignItems = 'center';
    el.style.padding = '3px 9px';
    el.style.borderRadius = '9999px';
    el.style.fontSize = '0.72rem';
    el.style.fontWeight = '700';
    el.style.letterSpacing = '0.02em';
    el.style.whiteSpace = 'nowrap';

    if (op.includes('delete') || op.includes('remove') || op.includes('archive')) {
      el.style.backgroundColor = '#fef2f2';
      el.style.color = '#b91c1c';
      el.style.border = '1px solid #fecaca';
    } else if (op.includes('creat') || op.includes('add') || op.includes('restore')) {
      el.style.backgroundColor = '#ecfdf5';
      el.style.color = '#047857';
      el.style.border = '1px solid #a7f3d0';
    } else if (op.includes('modif') || op.includes('edit')) {
      el.style.backgroundColor = '#fffbeb';
      el.style.color = '#b45309';
      el.style.border = '1px solid #fef08a';
    } else if (op.includes('email')) {
      el.style.backgroundColor = '#f0f9ff';
      el.style.color = '#0284c7';
      el.style.border = '1px solid #bae6fd';
    } else if (op.includes('read') || op.includes('download') || op.includes('view')) {
      el.style.backgroundColor = '#eff6ff';
      el.style.color = '#1d4ed8';
      el.style.border = '1px solid #bfdbfe';
    } else {
      el.style.backgroundColor = '#f1f5f9';
      el.style.color = '#475569';
      el.style.border = '1px solid #cbd5e1';
    }
  }
}
