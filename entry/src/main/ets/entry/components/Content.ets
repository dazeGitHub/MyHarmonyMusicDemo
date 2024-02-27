import { GridConstants } from '../../base/constants/GridConstants';
import { AlbumCover } from './AlbumCover';
import { PlayList } from './PlayList';

@Component
export struct Content {
  @Link currentBreakpoint: string;


  build() {
      GridRow(){
        GridCol({ span: { sm: GridConstants.SPAN_TWELVE, md: GridConstants.SPAN_SIX, lg: GridConstants.SPAN_FOUR } }){
          AlbumCover({ currentBreakpoint: $currentBreakpoint })
        }.backgroundColor(Color.Gray)

        GridCol({ span: { sm: GridConstants.SPAN_TWELVE, md: GridConstants.SPAN_SIX, lg: GridConstants.SPAN_FOUR } }){
          PlayList({ currentBreakpoint: $currentBreakpoint })
        }.borderRadius($r('app.float.playlist_border_radius'))
      }.height('100%')
    .onBreakpointChange((breakpoints: string) => {
      this.currentBreakpoint = breakpoints;
    })
  }
}