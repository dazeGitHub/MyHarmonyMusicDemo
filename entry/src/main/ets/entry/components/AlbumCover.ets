import { BreakpointConstants } from '../../base/constants/BreakpointConstants';
import { StyleConstants } from '../../base/constants/StyleConstants';
import { AlbumComponent } from './AlbumComponent';

@Component
export struct AlbumCover {
  @Link currentBreakpoint: string;

  build() {
    if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM) {
      AlbumComponent({ currentBreakpoint: $currentBreakpoint })
    } else {
      AlbumComponent({ currentBreakpoint: $currentBreakpoint })
        .height(StyleConstants.FULL_HEIGHT)
    }
  }
}