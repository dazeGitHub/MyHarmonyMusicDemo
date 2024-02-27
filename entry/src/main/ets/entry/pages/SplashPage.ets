import router from '@ohos.router'
import { RoutePath } from '../router/RouterParh'

@Entry
@Component
struct SplashPage {
  aboutToAppear(){
    setTimeout(()=>{
      router.replaceUrl({url:RoutePath.MainPage})
    },2000)
  }

  build() {
    Stack() {
      Image($r('app.media.splash_image')).objectFit(ImageFit.Fill)
    }.width("100%").height("100%").backgroundColor($r("app.color.white")).alignContent(Alignment.Center)
  }
}