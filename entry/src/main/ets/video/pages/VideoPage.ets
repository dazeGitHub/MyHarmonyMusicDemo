import { PageState } from '../Constant';
import { VideoPlayView } from '../view/VideoPlayView';
import { initializeOnStartup, VideoItem } from '../viewmodel/VideoViewModel';

@Entry
@Component
export struct VideoPage  {
  //@Link @Watch("tabIndexChange") tabCurrentIndex: number;
  @State videoArray: Array<VideoItem> = [];
  @State pageState: PageState = PageState.Loading;

  @State play:boolean = false;

  // tabIndexChange() {
  //
  //   if (this.tabCurrentIndex === 1) {
  //     // 切换到视频页面，初始化视频数据
  //     this.pageState = PageState.Success;
  //     this.videoArray = initializeOnStartup();
  //     this.play = true;
  //   } else {
  //     this.play = false;
  //   }

// }
// }

  aboutToAppear(){
      // if (this.tabCurrentIndex === 1) {
        // 切换到视频页面，初始化视频数据
        this.pageState = PageState.Success;
        this.videoArray = initializeOnStartup();
        this.play = true;
      // } else {
      //   this.play = false;
      // }
  }

  build() {
    Column() {
      if (this.pageState === PageState.Success) {

        // 视频页面
        VideoPlayView({ videoArray: $videoArray,play:$play })

      }
    }
  }
}