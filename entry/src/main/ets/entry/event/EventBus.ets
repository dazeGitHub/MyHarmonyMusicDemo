export class EventKeys {
  //展示loading的事件处理EventID
  static readonly LOADING_DIALOG_EVENT = 0x10000
}

/**
 * 对应的事件
 */
export const loadingEvent = {
  eventId: EventKeys.LOADING_DIALOG_EVENT
}

export function LoadingDialogEvent(showLoading: boolean, loadingTips: string = "加载中...") {
  return {
    data: {
      "showLoading": showLoading,
      "loadingTips": loadingTips
    }
  }
}