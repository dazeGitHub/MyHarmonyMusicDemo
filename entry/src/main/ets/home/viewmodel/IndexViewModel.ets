import IndexItem from './IndexItem';

/**
 * Home page information data processing class.
 */
class IndexViewModel {
  /**
   * Data information on the home page.
   *
   * @returns IndexItem array.
   */
  getIndexItemList(): IndexItem[] {
    let IndexItemList: IndexItem[] = [];
    IndexItemList.push(new IndexItem("测试数据", "测试数据",
      "播放音乐", $r('app.media.img'),
      'pages/PageList'));
    IndexItemList.push(new IndexItem("测试数据", "测试数据",
      "测试", $r('app.media.img'),
      'pages/Live'));
    return IndexItemList;
  }
}

export default new IndexViewModel();