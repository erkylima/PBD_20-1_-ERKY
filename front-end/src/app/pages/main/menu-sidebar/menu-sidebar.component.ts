import {
    Component,
    OnInit,
    AfterViewInit,
    ViewChild,
    Output,
    EventEmitter
} from '@angular/core';
import {AppService} from 'src/app/utils/services/app.service';

@Component({
    selector: 'app-menu-sidebar',
    templateUrl: './menu-sidebar.component.html',
    styleUrls: ['./menu-sidebar.component.scss']
})
export class MenuSidebarComponent implements OnInit, AfterViewInit {
    @ViewChild('mainSidebar', {static: false}) mainSidebar;
    @Output() mainSidebarHeight: EventEmitter<any> = new EventEmitter<any>();
    constructor(public appService: AppService) {}
    nome = localStorage.getItem('nome');

    role = localStorage.getItem('role');

    roleAdmin() {
        return this.role == 'ROLE_ADMIN';
    }
    roleUser() {
        return this.role == 'ROLE_USER';
    }
    roleOficina() {
        return this.role == 'ROLE_OFICINA';
    }

    ngOnInit() {}

    ngAfterViewInit() {
        this.mainSidebarHeight.emit(
            this.mainSidebar.nativeElement.offsetHeight
        );
    }
}
