import common from '@ohos.app.ability.common';
import media from '@ohos.multimedia.media';
import { BackgroundUtil } from '../../base/utils/BackgroundUtil';
import { Logger } from '../../base/utils/Logger';
import { MediaTools } from '../../base/utils/MediaTools';
import { AudioPlayerState, MusicPlayMode } from '../viewmodel/MusicData';
import { MusicList } from '../viewmodel/MusicListViewModel';
import { SongItem } from '../viewmodel/SongData';
import SongItemBuilder from './SongItemBuilder';


const TAG = 'MediaService'

//工具类 主要解决 是audio的全生命周期管理
export class MediaService{
  private context: common.UIAbilityContext | undefined = AppStorage.Get('context');
  public avPlayer: media.AVPlayer | null = null;
  private isFirst:boolean =true;
  private isPrepared:boolean =false;
  private musicIndex:number = 0;
  private songList:SongItem[] = MusicList;
  private songItemBuilder:SongItemBuilder;
  private isCurrent: boolean = true;
  private state: AudioPlayerState = AudioPlayerState.IDLE;
  private songItem: SongItem = new SongItem();
  private playMode: MusicPlayMode = MusicPlayMode.ORDER;

  constructor() {
    this.songItemBuilder = new SongItemBuilder();
    this.initAudioPlayer();
  }

  initAudioPlayer() {
    media.createAVPlayer().then(
        async (avPlayer:media.AVPlayer)=>{
          if (avPlayer !== null) {
              this.avPlayer = avPlayer;
              this.setAVPlayerCallback()
          }
        }
    ).catch((error: Error) => Logger.error(TAG, 'this avPlayer: ',
      `catch error happened, Error cause : ${JSON.stringify(error)}`));
  }

  setAVPlayerCallback() {
    if (!this.avPlayer || this.avPlayer === null) {
      Logger.error(TAG, `Invoke avPlayer failed`);
      return;
    }
    this.avPlayer.on('seekDone', (seekDoneTime: number) => {
      this.isCurrent = true;
      Logger.info(TAG, `AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    });

    this.avPlayer.on('error', (err) => {
      Logger.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      if (this.avPlayer) this.avPlayer.reset();
    });

    this.avPlayer.on('timeUpdate', (updateTime: number) => {
      if (this.isCurrent) {
        AppStorage.SetOrCreate('currentTime', MediaTools.msToCountdownTime(updateTime));
        AppStorage.SetOrCreate<number>('progress', updateTime);
      }
    });
    //stateChange
    this.avPlayer.on('stateChange', async (state: media.AVPlayerState) => {
      let stateString = state.toString();
      switch (stateString) {
        case 'idle':
          Logger.info(TAG, 'AVPlayer state idle called.');
          this.state = AudioPlayerState.IDLE;
          this.songItem = await this.songItemBuilder.build(this.songList[this.musicIndex]);
          let url = this.songItemBuilder.getRealUrl();
          if (url && this.avPlayer) {
            let avFileDescriptor: media.AVFileDescriptor =
              { fd: url.fd, offset: url.offset, length: url.length };
            this.avPlayer.fdSrc = avFileDescriptor;
          }
          break;
        case 'initialized':
          Logger.info(TAG, 'AVPlayer state initialized called.');
          this.state = AudioPlayerState.INITIALIZED;
          if (this.avPlayer) {
            this.avPlayer.prepare().then(() => {
              Logger.info(TAG, 'AVPlayer prepare succeeded.');
            }, (err: Error) => {
              Logger.error(TAG, `Invoke prepare failed, Error cause : ${JSON.stringify(err)}`);
            });
          }
          break;
        case 'prepared':
          Logger.info(TAG, 'AVPlayer state prepared called.');
          this.state = AudioPlayerState.PREPARED;
          this.isPrepared = true;
          // AppStorage.SetOrCreate('totalTime', MediaTools.msToCountdownTime(this.getDuration()));
          // AppStorage.SetOrCreate('progressMax', this.getDuration());
          if (this.avPlayer) this.avPlayer.play();
          Logger.info(TAG, 'AVPlayer prepared succeeded.');
          break;
        case 'playing':
          Logger.info(TAG, 'AVPlayer state playing called.');
          this.state = AudioPlayerState.PLAY;
          break;
        case 'paused':
          Logger.info(TAG, 'AVPlayer state paused called.');
          this.state = AudioPlayerState.PAUSE;
          break;
        case 'completed':
          Logger.info(TAG, 'AVPlayer state completed called.');
          this.state = AudioPlayerState.COMPLETED;
          this.playNextAuto(false);
          break;
        case 'stopped':
          Logger.info(TAG, 'AVPlayer state stopped called.');
          this.state = AudioPlayerState.STOP;
          if (this.avPlayer) this.avPlayer.reset();
          break;
        case 'released':
          Logger.info(TAG, 'AVPlayer state released called.');
          this.state = AudioPlayerState.RELEASED;
          break;
        default:
          Logger.info(TAG, 'AVPlayer state unknown called.');
          this.state = AudioPlayerState.UNKNOWN;
          break;
      }
      this.updateIsPlay(this.state === AudioPlayerState.PLAY);
    })
  }

  updateIsPlay(isPlay: boolean) {
    AppStorage.SetOrCreate<boolean>('isPlay',isPlay);
  }

  public static getInstance():MediaService {
    let mediaService:MediaService | undefined = AppStorage.Get('midiaService');
    if(!mediaService){
      mediaService = new MediaService();
      AppStorage.SetOrCreate('midiaService',mediaService);
    }
    return mediaService;
  }

  //=================================封装一些public 方法==========================================
  private _pre(seekMs?:number){
    Logger.info(TAG, 'AVPlayer play() isPrepared:' + this.isPrepared + ', state:' + this.state + '，seek:' + seekMs);
    if (this.avPlayer) {
      this.avPlayer.prepare().then(() => {
      }).catch((error: Error) => {
        if (this.avPlayer) {
          Logger.error(TAG, `start error ${JSON.stringify(error)} avplayer ${this.avPlayer.state}`)
          this.state = AudioPlayerState.ERROR;
          this.updateIsPlay(false);
          this.isPrepared = false;
          let url = this.songItemBuilder.getRealUrl();
          if (url && this.avPlayer) {
            Logger.info(TAG, 'loadAsset avPlayer.url:' + this.avPlayer.fdSrc);
            let avFileDescriptor: media.AVFileDescriptor = { fd: url.fd, offset: url.offset, length: url.length };
            this.avPlayer.fdSrc = avFileDescriptor;
          }
        }
      });
    }
  }

  public getFirst(){
    return this.isFirst;
  }


  public async play(){
    Logger.info(TAG, 'AVPlayer play() isPrepared:' + this.isPrepared + ', state:' + this.state);
    BackgroundUtil.startContinuousTask(this.context);
    if(!this.isPrepared){
      this._pre(0);
    }else{
      if(this.avPlayer){
        this.avPlayer.play().then(() => {
          Logger.info(TAG, 'progressTime play() current time:' + this.getAudioCurrentTime());
          this.seek(this.getAudioCurrentTime());
          this.updateIsPlay(true);
          this.state = AudioPlayerState.PLAY;
        })
      }
    }
  }

  public async pause(){
    Logger.info(TAG, 'AVPlayer pause() isPrepared:' + this.isPrepared + ', state:' + this.state);
    if (this.isPrepared && this.state == AudioPlayerState.PLAY && this.avPlayer) {
      this.avPlayer.pause().then(() => {
        this.state = AudioPlayerState.PAUSE;
        this.updateIsPlay(false);
      });
    }
  }

  public async playNextAuto(isControl:boolean){
    Logger.info(TAG, 'playNextAuto mode:' + this.playMode);
    switch (this.playMode){
      case MusicPlayMode.SINGLE_CYCLE:
      if(isControl){
        this.playNext();
      }else{
        if(this.avPlayer) this.avPlayer.play();
      }
      break;
      case MusicPlayMode.ORDER:
        this.playNext();
      break;
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      default :
      break;
    }
  }

  playRandom() {
    let num = Math.round(Math.random()*(this.songList.length-1));
    if(this.musicIndex === num){
      this.playRandom();
    }else {
      this.updateMusicIndex(num);
      this.loadMusic(num);
    }
    Logger.info(TAG, 'play Random:' + this.musicIndex);
  }

  private playNext() {
    Logger.info(TAG, 'playNext Index:' + this.musicIndex + ', length-1:' + (this.songList.length - 1));
    if(this.musicIndex === this.songList.length-1){
      this.loadMusic(0);
    }else {
      this.loadMusic(this.musicIndex+1);
    }
  }



  private updateMusicIndex(musicIndex:number){
    AppStorage.SetOrCreate('selectIndex',musicIndex);
    if(this.musicIndex!=musicIndex){
      this.musicIndex = musicIndex;
    }
  }

  public  async loadMusic(musicIndex: number) {
    if (musicIndex >= this.songList.length) {
      Logger.error(TAG, `current musicIndex ${musicIndex}`);
      return;
    }
    BackgroundUtil.startContinuousTask(this.context);
    this.updateMusicIndex(musicIndex);
    if(this.isFirst){
      this.isFirst = false;
      this.songItem = await this.songItemBuilder.build(this.songList[this.musicIndex]);
      let url = this.songItemBuilder.getRealUrl();
      if (url && this.avPlayer) {
        Logger.info(TAG, 'loadAsset avPlayer.url:' + this.avPlayer.fdSrc);
        let avFileDescriptor: media.AVFileDescriptor = { fd: url.fd, offset: url.offset, length: url.length };
        this.avPlayer.fdSrc = avFileDescriptor;
      }
    }else {
      await this.stop();
    }
  }

  public playPrevious(){
    Logger.info(TAG, 'playPrevious mode:' + this.playMode);
    switch (this.playMode){
      case MusicPlayMode.SINGLE_CYCLE:
      case MusicPlayMode.ORDER:
        if(this.musicIndex === 0){
          this.updateMusicIndex(this.songList.length-1)
        }else{
          this.updateMusicIndex(this.musicIndex-1)
        }
        this.loadMusic(this.musicIndex);
        break;
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      default :
        break;
    }
  }


  public async stop(){
    if(this.isPrepared && this.avPlayer) {
      Logger.info(TAG, "stop()");
      await this.avPlayer.stop()
      this.updateIsPlay(false);
      this.state = AudioPlayerState.PAUSE
    }
  }


  private  async reset(){
    Logger.info(TAG, "reset()");
    await this.songItemBuilder.release();
    if(this.avPlayer) {
      await this.avPlayer.reset()
    }
    this.isPrepared = false;
  }

  public release(){
    this.updateIsPlay(false);
    this.stop();
    this.reset();
    if(this.avPlayer) {
       this.avPlayer.release()
    }
    this.state = AudioPlayerState.IDLE;
    if(this.context) BackgroundUtil.stopContinuousTask(this.context);
  }

  public seek(ms:number){
    if (this.isPrepared && this.state !=AudioPlayerState.ERROR){
    let seekMode = this.getAudioCurrentTime()<ms?0:1;
    let time = (ms<=0?0:(ms >= this.getAudioDuration()?this.getAudioDuration():ms));
    this.isCurrent = false;
      if(this.avPlayer) this.avPlayer.seek(time,seekMode);
    }
  }


  private getAudioCurrentTime(){
    if(this.avPlayer&&this.isPrepared){
      return this.avPlayer.currentTime;
    }
    return 0;
  }


  private getAudioDuration(){
    if(this.avPlayer&&this.isPrepared){
      return this.avPlayer.duration;
    }
    return 0;
  }


}