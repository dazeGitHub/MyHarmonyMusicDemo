import { BreakpointConstants } from '../../base/constants/BreakpointConstants';
import { GridConstants } from '../../base/constants/GridConstants';
import { StyleConstants } from '../../base/constants/StyleConstants';
import { BreakpointType } from '../../base/utils/BreakpointSystem';
import { OptionItem, optionList} from '../viewmodel/SongListData'
@Preview
@Component
export struct AlbumComponent {
  @Link currentBreakpoint: string;
  @State imgHeight:number = 0;

  // 封面
  @Builder
  CoverImage() {
    Stack({alignContent:Alignment.BottomStart}){
      Image($r('app.media.ic_album'))
        .width(StyleConstants.FULL_WIDTH)
        .aspectRatio(1)
        .borderRadius($r('app.float.album_cover_border_radius'))
        .onAreaChange((oldArea: Area, newArea: Area) => {
          this.imgHeight = newArea.height as number;
        })
      Text($r('app.string.collection_num'))
        .letterSpacing(1)
        .fontColor(Color.White)
        .fontSize(new BreakpointType({
          sm: $r('app.float.collection_font_sm'),
          md: $r('app.float.collection_font_md'),
          lg: $r('app.float.collection_font_lg')
        }).getValue(this.currentBreakpoint))
        .translate({
          x: 10,
          y: -10
        })
    }.width('100%')
    .height('100%')
    .aspectRatio(1)
  }
  // 文字
  @Builder
  CoverIntroduction() {
    Column() {
      Text($r('app.string.list_name'))
        .opacity($r('app.float.album_name_opacity'))
        .fontWeight(500)
        .fontColor($r('app.color.album_name_introduction'))
        .fontSize(new BreakpointType({
          sm: $r('app.float.list_font_sm'),
          md: $r('app.float.list_font_md'),
          lg: $r('app.float.list_font_lg')
        }).getValue(this.currentBreakpoint))
        .margin({ bottom: $r('app.float.album_name_margin') })

      Text($r('app.string.playlist_Introduction'))
        .opacity($r('app.float.introduction_opacity'))
        .width(StyleConstants.FULL_WIDTH)
        .fontWeight(400)
        .fontColor($r('app.color.album_name_introduction'))
        .fontSize(new BreakpointType({
          sm: $r('app.float.introduction_font_sm'),
          md: $r('app.float.introduction_font_md'),
          lg: $r('app.float.introduction_font_lg')
        }).getValue(this.currentBreakpoint))
    }
    .width(StyleConstants.FULL_WIDTH)
    .height(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ?
    this.imgHeight : $r('app.float.introduction_height'))
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .padding({
      left: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? $r('app.float.introduction_padding') : 0
    })
    .margin({
      top: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? 0 : $r('app.float.introduction_margin_top'),
      bottom: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ?
        0 : $r('app.float.introduction_margin_bottom')
    })
  }
  //icon
  @Builder
  CoverOptions() {
    Row(){
      ForEach(optionList,(item:OptionItem)=>{
        Column(){
          Image(item.image)
            .height($r('app.float.option_image_size'))
            .width($r('app.float.option_image_size'))
          Text(item.text)
            .fontColor($r('app.color.album_name_introduction'))
            .fontSize(new BreakpointType({
              sm: $r('app.float.option_font_sm'),
              md: $r('app.float.option_font_md'),
              lg: $r('app.float.option_font_lg')
            }).getValue(this.currentBreakpoint))
        }
        .onClick(item.action ? item.action : () => {})
      },(item: OptionItem, index?: number) => index + JSON.stringify(item))
    }.height(70)
    .width(StyleConstants.FULL_WIDTH)
    .padding({
      left: $r('app.float.options_padding'),
      right: $r('app.float.options_padding')
    })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build(){
    Column(){
      GridRow(){
        GridCol({
         span:{
           sm: GridConstants.SPAN_FOUR,
           md: GridConstants.SPAN_TWELVE,
           lg: GridConstants.SPAN_TWELVE
         }
        }){
          this.CoverImage()
        }
        GridCol({
          span:{
            sm: GridConstants.SPAN_EIGHT,
            md: GridConstants.SPAN_TWELVE,
            lg: GridConstants.SPAN_TWELVE
          }
        }){
          this.CoverIntroduction()
        }
        GridCol({
          span:{
            sm: GridConstants.SPAN_TWELVE,
            md: GridConstants.SPAN_TWELVE,
            lg: GridConstants.SPAN_TWELVE
          }
        }){
          this.CoverOptions()
        }
        .padding({
          top: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? $r('app.float.option_margin') : 0,
          bottom: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? $r('app.float.option_margin') : 0
        })

      }
      .padding({
        top: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ?
        $r('app.float.cover_padding_top_sm') : $r('app.float.cover_padding_top_other'),
        left: new BreakpointType({
          sm: $r('app.float.album_padding_sm'),
          md: $r('app.float.album_padding_md'),
          lg: $r('app.float.album_padding_lg')
        }).getValue(this.currentBreakpoint),
        right: new BreakpointType({
          sm: $r('app.float.album_padding_sm'),
          md: $r('app.float.album_padding_md'),
          lg: $r('app.float.album_padding_lg')
        }).getValue(this.currentBreakpoint)
      })
    }
    .margin({
      left: new BreakpointType({
        sm: $r('app.float.music_list_cover_margin_sm'),
        md: $r('app.float.music_list_cover_margin_md'),
        lg: $r('app.float.music_list_cover_margin_lg')
      }).getValue(this.currentBreakpoint),
      right: new BreakpointType({
        sm: $r('app.float.music_list_cover_margin_sm'),
        md: $r('app.float.music_list_cover_margin_md'),
        lg: $r('app.float.music_list_cover_margin_lg')
      }).getValue(this.currentBreakpoint)
    })
  }
}