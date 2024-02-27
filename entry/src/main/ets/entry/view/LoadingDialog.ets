@Preview
@CustomDialog
export struct LoadingDialog{
  @Prop loadingTips: string
  @State rotateAngle: number = 0
  //弹窗控制器
  controller: CustomDialogController
  aboutToAppear(){
    this.rotateAngle = 360
  }

  build(){
    Stack() {
      Column() {
        Image($r('app.media.common_loading'))
          .height(50)
          .width(50)
          .rotate({ angle: this.rotateAngle })
          .animation({
            duration: 500,
            iterations: -1,
            curve: Curve.Friction
          })
        Text(this.loadingTips)
          .fontSize(15)
          .margin({ top: 10 })
      }
      .justifyContent(FlexAlign.Center)
      .height(150)
      .width(150)
      .backgroundColor($r('app.color.white'))
      .border({ radius: 5})
    }
  }
}