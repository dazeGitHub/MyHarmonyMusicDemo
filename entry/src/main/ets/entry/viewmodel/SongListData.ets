import router from '@ohos.router';
import { RoutePath } from '../router/RouterParh';

const optionList:OptionItem[] = [
  { image: $r('app.media.ic_collect'), text: $r('app.string.collect') },
  { image: $r('app.media.ic_download'), text: $r('app.string.download') },
  { image: $r('app.media.ic_comments'), text: $r('app.string.comment_'), action: () => {
    router.pushUrl({
      url: RoutePath.MusicCommListPage
    }, router.RouterMode.Single)
  } },
  { image: $r('app.media.ic_share'), text: $r('app.string.share') }
]

class OptionItem{
  image: Resource = $r('app.media.ic_collect');
  text?: Resource;
  action?: () => void;
}

export {optionList,OptionItem}
