import router from '@ohos.router'
@Entry
@Component
struct SplashPage {
  @State flag:boolean = false
  onPageShow(){
    animateTo({duration:1000,onFinish:()=>{
      setTimeout(()=>{
        router.replaceUrl({url:'pages/Index'})
      },2000)
    }},()=>{
      this.flag = true
    })
  }
  build() {
    Column(){
      if (this.flag){
        Image($r('app.media.ic_logo'))
          .logoStyle()
          .transition({type:TransitionType.Insert,opacity:0,translate:{x:-200}})
        Text('快速单词记忆神器')
          .titleStyle()
          .transition({type:TransitionType.Insert,opacity:0,translate:{x:200}})
      }
      Blank()
      Text('Atguigu Harmony Project')
        .footerStyle()
    }
    .bgStyle()
  }


}
@Extend(Text) function footerStyle() {
  .fontSize(12)
    .fontColor('#546B9D')
    .fontWeight(FontWeight.Bold)
    .margin({ bottom: 30 })
}

@Extend(Text) function titleStyle() {
  .fontSize(21)
  .fontColor(Color.White)
  .fontWeight(FontWeight.Bold)
  .margin({ top: 15 })
}

@Styles function bgStyle() {
  .width('100%')
  .height('100%')
  .backgroundImage($r('app.media.img_splash_bg'))
  .backgroundImageSize({ width:
  '100%', height: '100%' })
}
@Extend(Image) function logoStyle() {
  .width(90)
  .height(90)
  .margin({ top: 120 })
}