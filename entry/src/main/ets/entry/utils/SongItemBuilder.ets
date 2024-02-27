import common from '@ohos.app.ability.common';
import resourceManager from '@ohos.resourceManager';
import { Logger } from '../../base/utils/Logger';
import { SongItem } from '../viewmodel/SongData';

export default class SongItemBuilder {
  private context: common.UIAbilityContext | undefined = AppStorage.Get('context');
  private realUrl?: resourceManager.RawFileDescriptor;
  private songItem: SongItem | null = null;

  public async build(songItem: SongItem): Promise<SongItem> {
    this.songItem = songItem;
    if (!this.context) {
      return this.songItem;
    }
    let rawfileFd = await this.context.resourceManager.getRawFd(songItem.src)
      .catch((error: Error) => {
        Logger.error(`resourceManager error cause : ${JSON.stringify(error)}`);
      })
    if (rawfileFd) {
      this.realUrl = rawfileFd;
    } else {
      Logger.error('get rawfileFd failed')
    }
    Logger.info('MediaAssetBuilder build realUrl:' + this.realUrl);
    return this.songItem;
  }

  public getRealUrl(): resourceManager.RawFileDescriptor | undefined {
    return this.realUrl;
  }

  public async release(): Promise<void> {
    if (this.context && this.context !== null && this.songItem !== null) {
      this.context.resourceManager.closeRawFd(this.songItem.src);
    }
    this.songItem = null;
  }
}