import { BreakpointConstants } from '../../base/constants/BreakpointConstants';
import { BreakpointSystem } from '../../base/utils/BreakpointSystem';
import { Content } from '../components/Content';
import { Header } from '../components/Header';
import { Play } from '../components/Play';

@Entry
@Component
struct PageList {
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  @State currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;

  aboutToAppear(){
    this.breakpointSystem.register();
  }
  aboutToDisappear(){
    this.breakpointSystem.unregister();
  }


  build() {
    Stack({alignContent:Alignment.Top}){
      Header({currentBreakpoint:this.currentBreakpoint})
      Content({currentBreakpoint:this.currentBreakpoint})
      Play({currentBreakpoint:this.currentBreakpoint})
    }
    .width("100%")
    .backgroundColor(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ?
    $r('app.color.page_background_sm') : $r('app.color.page_background_other'))
    
  }
}