import { VideoItem } from '../viewmodel/VideoViewModel';
import { VideoContent } from './VideoContent';

//
// @Entry
@Component
export struct VideoPlayView {
  @State swiperIndex:number = 0;
  @Link videoArray:Array<VideoItem>
  @Link play:boolean

  build() {
    Swiper(){
      ForEach(this.videoArray,(videos: VideoItem, index: number)=>{
        //play
        VideoContent({
          swiperIndex:$swiperIndex,
          item:videos,
          barPosition:index,
          isPlay:$play
        })
      },videos=>JSON.stringify(videos))
    }.width("100%")
    .height("100%")
    .indicator(false)
    .loop(false)
    .vertical(true)
    .onChange((index:number)=>{
        this.swiperIndex = index
    })
  }
}