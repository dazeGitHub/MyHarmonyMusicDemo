import emitter from '@ohos.events.emitter'
import { HomePage } from '../../home/pages/HomePage'
import { VideoPage } from '../../video/pages/VideoPage'
import { loadingEvent } from '../event/EventBus'
import { LoadingDialog } from '../view/LoadingDialog'
import MainViewModel from '../viewmodel/MainViewModel'
import { TabItem } from '../viewmodel/TabItem'

@Entry
@Component
struct MainPage {
  @State selectedIndex: number = 0
  @Provide homeTabSelected: number = 0
  @State loadingTips: string = "加载中..."
  @State loadingShow: boolean = false
  loadingDialogController:CustomDialogController = new CustomDialogController({
    builder:LoadingDialog({ loadingTips: this.loadingTips }),
    autoCancel: false,
    gridCount: 2,
    cancel: () => {
      this.loadingShow = false
    }
  })

  aboutToAppear() {
    emitter.on(loadingEvent, (event) => {
      if (event.data.showLoading == true && !this.loadingShow) {
        this.loadingShow = true
        this.loadingTips = event.data.loadingTips
        this.loadingDialogController.open()
      } else if (event.data.showLoading == false) {
        this.loadingDialogController.close()
        this.loadingShow = false
      }
    })
  }

  aboutToDisappear(){
    this.loadingDialogController = null
  }



  build() {

    Tabs({
      index:this.selectedIndex,
      barPosition:BarPosition.End,
    }){
      TabContent(){
        //主页
        HomePage()
      }.tabBar(this.TabBottom(MainViewModel.tabTitle[0], 0))
      TabContent(){
        //视频
        VideoPage()
      }.tabBar(this.TabBottom(MainViewModel.tabTitle[1], 1))
      TabContent(){

      }.tabBar(this.TabBottom(MainViewModel.tabTitle[2], 2))
      TabContent(){

      }.tabBar(this.TabBottom(MainViewModel.tabTitle[3], 3))
    }

  }

  @Builder TabBottom(item:TabItem,index:number){
    Column() {
      Image(this.selectedIndex == index ? item.imageActivated : item.imageOriginal)
        .height(21)
        .width(21)
        .margin({
          top: 8,
          bottom: 5
        })
      Text(item.title)
        .width('100%')
        .height(14)
        .fontSize(10)
        .fontWeight(500)
        .fontColor(this.selectedIndex === index ? Color.Red : Color.White)
        .textAlign(TextAlign.Center)
        .margin({
          bottom: 7
        })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Grey)
  }
}