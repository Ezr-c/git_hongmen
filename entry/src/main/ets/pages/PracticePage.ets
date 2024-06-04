// 引入页面状态枚举类型
import { PracticeStatus } from '../enums/PracticeStatus'
import { Question, getRandomQuestions } from '../model/Question'
import { AnswerStatus } from '../enums/AnswerStatus'
import promptAction from '@ohos.promptAction'
import { OptionStatus } from '../enums/OptionStatus'
import { convertMillisecondsToTime } from '../utils/DateUtil'

@Component
export struct PracticePage {
  @State practiceStatus: PracticeStatus = PracticeStatus.Stopped // 默认停止状态 练习状态
  @State totalCont: number = 5 // 本轮题目总数
  @State questions: Question[] = getRandomQuestions(this.totalCont) // 默认获取题目
  @State currentIndex: number = 0 // 题目数组下标
  @State answer: AnswerStatus = AnswerStatus.Answering // 答题按钮状态
  @State selectedOption: string = '' // 被选择的选项
  @State answeredCont: number = 0 // 本轮答题数量
  @State rightCont: number = 0 // 本轮正确数量
  timerController: TextTimerController = new TextTimerController(); // 计时控制器
  @State timeUsed: number = 0
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ResultDialog({
      answeredCont: this.answeredCont,
      timeUsed: this.timeUsed,
      rightCont: this.rightCont,
      resetPractice:()=>{
        this.questions = getRandomQuestions(this.totalCont)
        this.answeredCont = 0
        this.rightCont = 0
        this.timeUsed = 0
        this.currentIndex = 0
        this.timerController.reset()
        this.answer = AnswerStatus.Answering
      },
      startPrarice:()=>{
        this.startPrarice()
      }
    }),
    customStyle: true,
    autoCancel:false
  })


  // 开始测试事件函数
  startPrarice() {
    this.practiceStatus = PracticeStatus.Running
    // todo 启动计时器
    this.timerController.start()
  }

  // 暂停测试事件函数
  pausePrarice() {
    this.practiceStatus = PracticeStatus.Paused
    // todo 停止计时器
    this.timerController.pause()
  }

  // 停止测试事件函数
  stopPrarice() {
    this.practiceStatus = PracticeStatus.Stopped
    // todo 停止计时器
    this.timerController.pause()
    // todo 弹窗
    this.dialogController.open()
  }

  build() {
    Column() {
      // 统计
      Column({ space: 10 }) {
        // 准确率
        StatItem({
          icon: $r('app.media.ic_accuracy'),
          name: '准确率',
          FontColor: Color.Black
        }) {
          Text((this.answeredCont === 0 ? 0 : (this.rightCont / this.answeredCont * 100).toFixed()) + '%')
            .width(100)
            .textAlign(TextAlign.Center)
        }
        // 进度
        StatItem({
          icon: $r('app.media.ic_progress'),
          name: '进度',
          FontColor: Color.Black
        }) {
          Progress({ value: this.answeredCont, total: this.totalCont })
            .width(100)
        }
        // 个数
        StatItem({
          icon: $r('app.media.ic_count'),
          name: '个数',
          FontColor: Color.Black
        }) {
          Button(this.totalCont.toString())
            .width(100)
            .height(25)
            .backgroundColor('#EBEBEB')
            .fontColor(Color.Black)
            .enabled(this.practiceStatus === PracticeStatus.Stopped)
            .onClick(() => {
              TextPickerDialog.show({
                range: ['5', '10', '15'],
                value: this.totalCont.toString(),
                onAccept: (value) => {
                  this.totalCont = parseInt(value.value)
                  this.questions = getRandomQuestions(this.totalCont)
                }
              })
            })
        }
        // 用时
        StatItem({
          icon: $r('app.media.ic_timer'),
          name: '用时',
          FontColor: Color.Black
        }) {
          Row() {
            TextTimer({ controller: this.timerController })
              .onTimer((utc: number, elapsedTime: number) => {
                this.timeUsed = elapsedTime
              })
          }
          .width(100)
          .justifyContent(FlexAlign.Center)
        }
      }.statBg()

      Column() {
        Text(this.questions[this.currentIndex].word)
          .wordStyle()

        Text(this.questions[this.currentIndex].sentence)
          .sentenceStyle()

      }

      Column({ space: 10 }) {
        ForEach(this.questions[this.currentIndex].options, (item: string) => {
          OptionButton({
            item: item,
            answer: this.answer,
            daan: this.questions[this.currentIndex].answer,
            selectedOption: this.selectedOption
          })
            .enabled(this.answer === AnswerStatus.Answering)
            .onClick(() => {
              if (this.practiceStatus !== PracticeStatus.Running) {
                promptAction.showToast({ message: '请先开始测试' })
                return
              }
              this.selectedOption = item
              this.answer = AnswerStatus.Answered
              if (this.currentIndex < this.questions.length - 1) {
                // 更新统计信息
                this.answeredCont++
                if (item === this.questions[this.currentIndex].answer) {
                  this.rightCont++
                  console.log('1')
                }
                setTimeout(() => {
                  // 更新统计信息
                  this.currentIndex++
                  this.answer = AnswerStatus.Answering
                }, 500)
              } else {
                this.stopPrarice()
                // this.answer = AnswerStatus.Answering
              }
            })


        })
      }

      Row({ space: 50 }) {
        Button('停止测试')
          .controlButton({
            bg: Color.Transparent,
            font: this.practiceStatus === PracticeStatus.Stopped ? Color.Gray : Color.Black,
            border: this.practiceStatus === PracticeStatus.Stopped ? Color.Gray : Color.Black
          })
          .enabled(this.practiceStatus !== PracticeStatus.Stopped)
          .onClick(() => {
            //  停止测试
            this.stopPrarice()
          })

        Button(this.practiceStatus === PracticeStatus.Running ? '暂停测试' : '开始测试')
          .controlButton({
            bg: this.practiceStatus === PracticeStatus.Running ? Color.Gray : Color.Black,
            border: this.practiceStatus === PracticeStatus.Running ? Color.Gray : Color.Black,
            font: Color.White
          })
          .onClick(() => {
            if (this.practiceStatus === PracticeStatus.Running) {
              // 暂停测试
              this.pausePrarice()
            } else {
              // 开始测试
              this.startPrarice()
            }
          })
      }
    }.PracticeBg()

  }
}

@CustomDialog
struct ResultDialog {
  controller: CustomDialogController = new CustomDialogController({
    builder: ResultDialog
  })
  answeredCont: number
  rightCont: number
  timeUsed: number
  resetPractice: () => void
  startPrarice:()=>void

  build() {
    Column({ space: 10 }) {
      Image($r('app.media.ic_close'))
        .width(25)
        .height(25)
        .alignSelf(ItemAlign.End)
        .onClick(() => {
          this.resetPractice()
          this.controller.close()
        })
      Column({ space: 10 }) {
        Image($r('app.media.img_post'))
          .width('100%')
          .borderRadius(10)
        StatItem({
          icon: $r('app.media.ic_timer'),
          name: '用时',
          FontColor: Color.Black
        }) {
          Text(convertMillisecondsToTime(this.timeUsed))
        }

        StatItem({
          icon: $r('app.media.ic_timer'),
          name: '准确率',
          FontColor: Color.Black
        }) {
          Text((this.answeredCont === 0 ? 0 : (this.rightCont / this.answeredCont * 100).toFixed()) + '%')
        }

        StatItem({
          icon: $r('app.media.ic_timer'),
          name: '个数',
          FontColor: Color.Black
        }) {
          Text(this.answeredCont.toString())
        }

        Divider()
        Row({ space: 30 }) {
          Button('再来一局')
            .controlButton({
              bg: Color.Transparent,
              border: Color.Black,
              font: Color.Black
            })
            .onClick(()=>{
              this.resetPractice()
              this.controller.close()
              this.startPrarice()
            })
          Button('登录打卡')
            .controlButton({
              bg: Color.Black,
              border: Color.Black,
              font: Color.White
            })
            .onClick(()=>{
              this.resetPractice()
              this.controller.close()
              // todo 登录打卡

            })
        }
      }
      .backgroundColor(Color.White)
      .width('100%')
      .padding(20)
      .borderRadius(10)
    }
    .backgroundColor(Color.Transparent)
    .width('80%')
  }
}

@Component
struct StatItem {
  icon: Resource
  name: string
  @BuilderParam StatComp: () => void
  FontColor: Color

  build() {
    Row() {
      Image(this.icon)
        .width(14)
        .height(14)
      Text(this.name)
        .fontWeight(FontWeight.Medium)
        .fontSize(14)
        .fontColor(this.FontColor)
      Blank()
      this.StatComp()
    }.width('100%')
    .height(30)
  }
}

@Component
struct OptionButton {
  item: string
  @State optionStatus: OptionStatus = OptionStatus.Default
  daan: string
  @Prop selectedOption: string
  @Prop @Watch('onAnswer') answer: AnswerStatus

  onAnswer() {
    // console.log(this.item)
    // console.log(this.selectedOption)
    if (this.item == this.daan) {
      this.optionStatus = OptionStatus.Right
      // console.log('变绿')
    } else {
      if (this.item === this.selectedOption) {
        this.optionStatus = OptionStatus.Wrong
        // console.log('红色')
      } else {
        this.optionStatus = OptionStatus.Default
      }
    }
  }

  getBgColor() {
    switch (this.optionStatus) {
      case OptionStatus.Right:
        return Color.Green
      case OptionStatus.Wrong:
        return Color.Red
      default:
        return Color.White
    }
  }

  build() {
    Button(this.item)
      .optionButton({
        bg: this.getBgColor(),
        font: this.optionStatus == OptionStatus.Default ? Color.Black : Color.White
      })
  }
}

@Extend(Column) function PracticeBg() {
  .width('100%')
  .height('100%')
  .justifyContent(FlexAlign.SpaceEvenly)
  .backgroundImage($r('app.media.img_practice_bg'))
  .backgroundImageSize({ width: '100%', height: '100%' })
}

@Styles function statBg() {
  .backgroundColor(Color.White)
  .width('90%')
  .padding(20)
  .borderRadius(20)
}

@Extend(Text) function wordStyle() {
  .fontSize(50)
  .fontWeight(FontWeight.Bold)
}

@Extend(Text) function sentenceStyle() {
  .fontSize(16)
  .fontColor(Color.Gray)
  .height(40)
  .fontWeight(FontWeight.Medium)
  .width('80%')
  .textAlign(TextAlign.Center)
}

@Extend(Button) function optionButton(color: {
  bg: Color,
  font: Color
}) {
  .width(240)
  .height(48)
  .fontSize(16)
  .type(ButtonType.Normal)
  .borderRadius(10)
  .fontColor(color.font)
  .backgroundColor(color.bg)
}

@Extend(Button) function controlButton(color: {
  bg: Color,
  font: Color,
  border: Color
}) {
  .fontSize(16)
  .borderWidth(1)
  .backgroundColor(color.bg)
  .fontColor(color.font)
  .borderColor(color.border)
}
