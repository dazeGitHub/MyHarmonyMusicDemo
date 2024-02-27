export class MainViewModel {
  tabTitle = [
    {
      index: 0,
      title: "首页",
      imageActivated: $r('app.media.icon_unsel_home'),
      imageOriginal: $r('app.media.icon_unsel_home')
    },
    {
      index: 1,
      title: "抖音",
      imageActivated: $r('app.media.icon_unsel_home'),
      imageOriginal: $r('app.media.icon_unsel_home')
    },
    {
      index: 2,
      title: "热门",
      imageActivated: $r('app.media.icon_unsel_home'),
      imageOriginal: $r('app.media.icon_unsel_home')
    },
    {
      index: 3,
      title: "我的",
      imageActivated: $r('app.media.icon_unsel_home'),
      imageOriginal: $r('app.media.icon_unsel_home')
    }
  ]
}
let mainViewModel = new MainViewModel()
export default mainViewModel as MainViewModel