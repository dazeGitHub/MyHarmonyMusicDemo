import router from '@ohos.router'
import { BreakpointConstants } from '../../base/constants/BreakpointConstants'
import { HomeConstants } from '../../base/constants/HomeConstants'

import IndexItem from '../viewmodel/IndexItem'
import IndexViewModel from '../viewmodel/IndexViewModel'

const searchSwiper: string[] = [
  '鸿蒙招聘4w',
  'go',
  "鸿蒙发布最新版本",
  "周教主加入鸿蒙"
]

@Entry
@Component
export struct HomePage {
  @State indexItemList: IndexItem[] = IndexViewModel.getIndexItemList();

  @Builder
  SearchTitle(){
    Flex({justifyContent:FlexAlign.SpaceBetween}){
      Row() {
        Image($r('app.media.search'))
          .width($r('app.float.vp_twenty'))
          .height($r('app.float.vp_twenty'))
          .margin({
            left: $r('app.float.vp_twelve'),
            right: $r('app.float.vp_eight')
          })
        Swiper() {
          ForEach(searchSwiper, (item: Resource) => {
            Column() {
              Text(item)
                .fontSize($r('app.float.small_font_size'))
                .fontColor(Color.Black)
            }
            .alignItems(HorizontalAlign.Start)
          },(item: Resource) => JSON.stringify(item))
        }.autoPlay(true)
        .loop(true)
        .vertical(true)
        .indicator(false)
      } .width('100%')
      .height($r('app.float.search_swiper_height'))
      .borderRadius($r('app.float.vp_twenty'))
      .backgroundColor(Color.Gray)
      .margin({ left:10,right: 10, top:10})
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignContent: FlexAlign.Center}) {
      this.SearchTitle()
      GridRow({
        breakpoints:{
          value: BreakpointConstants.BREAKPOINT_VALUE,
          reference: BreakpointsReference.WindowSize
        },
        columns:{
          sm: BreakpointConstants.COLUMN_SM,
          md: BreakpointConstants.COLUMN_MD,
          lg: BreakpointConstants.COLUMN_LG
        },
        gutter:{x: BreakpointConstants.GUTTER_X},
        direction: GridRowDirection.Row
      }){
        GridCol({
          span: {
            sm: BreakpointConstants.SPAN_SM,
            md: BreakpointConstants.SPAN_MD,
            lg: BreakpointConstants.SPAN_LG
          },
          offset: {
            md: BreakpointConstants.OFFSET_MD,
            lg: BreakpointConstants.OFFSET_LG
          }
        }){
          //开发自己的页面
          Column({ space: HomeConstants.COLUMN_SPACE }) {
            Text("我的首页")
            ForEach(this.indexItemList, (item: IndexItem) => {
              Stack() {
                Image(item.icon)
                  .width("100%")
                  .height($r('app.float.item_height'))
                  .borderRadius($r('app.float.item_border_radius'))
                Column() {
                  Text(item.title)
                    .fontSize($r('app.float.title_font_size'))
                    .fontColor(Color.White)
                  Text(item.description)
                    .fontSize($r('app.float.description_font_size'))
                    .opacity(HomeConstants.TEXT_OPACITY)
                    .fontColor(Color.White)
                    .margin({
                      top: $r('app.float.description_margin_top')
                    })
                  Blank()
                  Column() {
                    Button() {
                      Text(item.button)
                        .fontSize($r('app.float.button_font_size'))
                        .fontColor(Color.White)
                    }
                    .backgroundColor($r('app.color.button_background_color'))
                    .borderRadius($r('app.float.button_border_radius'))
                    .width($r('app.float.button_width'))
                    .height($r('app.float.button_height'))
                    .onClick(() => {
                      router.pushUrl({
                        url: item.url
                      }, router.RouterMode.Single);
                    })
                  }
                  .alignItems(HorizontalAlign.End)
                  .width("100%")
                }
                .width("100%")
                .height($r('app.float.item_height'))
                .borderRadius($r('app.float.item_border_radius'))
                .padding($r('app.float.item_padding'))
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.SpaceBetween)
              }
            }, (item: IndexItem, index?: number) => index + JSON.stringify(item))
          }
        }
      }
        .padding({
          top: $r('app.float.column_padding_top'),
          left: $r('app.float.column_padding_left'),
          right: $r('app.float.column_padding_right')
        })
    }
  }
}