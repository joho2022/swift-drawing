# swift-drawing
iOS 세번째 프로젝트

<details>
<summary>아이패드 앱 프로젝트</summary>

## 🎯주요 작업

- [x]  아이패드와 iOS 앱 프로젝트 생성 학습
- [x]  시스템 로그 함수 학습과 출력하기
- [x]  팩토리 방식을 학습하고 역할 분리하기
- [x]  화면에 표시하는 뷰와 뷰 데이터를 가지는 모델 구분하기

## 📚학습 키워드

### UUID

UUID 표준에 따라서 이름을 부여하게 된다면 고유성이 완벽하게 보장되지는 않지만, 실제로 사용할 때 중복될 가능성이 거의 없기 때문에 널리 사용되고 있다.

### UUID의 형식

총 36개의 문자열로 구성되어 있다. 32개의 실제 문자와 4개의 하이픈으로 구성되어 있다.
`E621E1F8-C36C-495A-93FC-0C247A3E6E5F`

### 팩토리 메소드 패턴

- 인스턴스 생성을 팩토리라는 곳에서 담당한다.

```swift
protocol RectangleModelFactoryProtocol {
    func createRectangleModel(size: Size, point: Point, backgroundColor: RGBColor, opacity: Int) -> RectangleModel
}

class RectangleFactory: RectangleModelFactoryProtocol {
    func createRectangleModel(size: Size, point: Point, backgroundColor: RGBColor, opacity: Int) -> RectangleModel {
        let uniqueID = generateRandomID()
        return RectangleModel(uniqueID: uniqueID, size: size, point: point, backgroundColor: backgroundColor, opacity: opacity)
    }
    
    private func generateRandomID() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyz0123456789"
        var segments = [String]()
        
        for _ in 0..<3 {
            let segment = (0..<3).map { _ in characters.randomElement()! }
            segments.append(String(segment))
        }

        return segments.joined(separator: "-")
    }
}
```

## 💻고민과 해결

<img width="827" alt="스크린샷 2024-03-18 오후 2 27 58" src="https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/867322f5-07e0-412e-ba8c-c6cbb7af54a5">

→ UUID의 각 구성 요소는 다양한 길이를 가져서, 지금 상황에 맞지 않다고 판단

각 3자리 형식의 문자열을 랜덤으로 생성하는 방식을 채택한다.

## 🤔결과

<img width="747" alt="스크린샷 2024-03-18 오후 3 05 49" src="https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/27535344-3b26-49d4-955b-1ce672690b0a">

## 📚추가학습

### 시스템 로그 함수

Apple의 로깅 시스템의 일부이며, 앱 및 시스템 서비스의 실행 중에 발생하는 정보, 경고 및 오류와 같은 정보를 기록한다.

- 이러한 로깅 시스템은 매우 낮은 성능 오버헤드로 설계되었기 때문에, 애플리케이션의 성능에 큰 영향을 주지 않고 로그에 기록한다.

os.log 주요 특징

1. 카테고리화: 로그를 다양한 카테고리로 분류할 수 있다. 빠르게 찾을 수 있음
2. 효율성: **`os.log`**를 사용할 때, 이러한 문자열 보간(string interpolation)이 실제 로그가 필요한 순간(즉, 그 로그 레벨이 활성화되어 있고 로그 메시지가 실제로 출력되어야 할 때)까지 평가되지 않는다. 이는 문자열을 미리 조합하고 메모리에 저장하는 대신, 실제로 필요할 때만 해당 작업을 수행한다, 결론적으로 불필요한 처리를 방지하여 성능에 미치는 영향을 최소화한다.
3. 동적 수준 설정: 로그 수준(info, debug, error…)을 동적으로 조정할 수 있다. 개발중에는 상제한 로그를 확인하고, 출시 버전에는 중요한 로그만 확인할 수 있다.
4. 통합된 로그 저장소: 여러 플랫폼에서 일관된 로깅 경험을 제공할 수 있다.

```swift
import os

private let logger = os.Logger(subsystem: "pro.DrawingApp.model", category: "ModelLogging")
logger.log(level: .info, "Rect1 \(rect1.description)")
```

subsystem: 앱의 전체 기능 또는 부분에 대한 고유한 문자열, 주로 번들 식별자를 사용한다

category: 관련성 있는 로그를 그룹화하는데 사용한다. networking, UI, database 등등

## 로그 레벨

### default

- 기본 로그 레벨
- 일반적인 시스템 작동 중에 정보를 제공하거나 특정 이벤트를 기록하는 데 사용
- 시스템 동작에 영향을 주지 않는 일반적인 정보에 적합하다.

### info

- 정보 제공용 로그 레벨
- default 보다는 덜 중요하지만 특정 상황에서 유용한 정보를 제공하는 데 사용
- 디버깅이나 추가적인 컨텍스트 제공에 유용하다
- 기본적으로 디바이스 로그에서는 보이지 않고, 개발 중이나 디버깅할 때 활성화하여 볼 수 있다

### debug

- 디버그용 로그 레벨
- 개발 중이나 문제 해결 시에만 세부 정보를 제공하는 데 사용한다
- 출시된 앱에서는 캡쳐되지 않는다.

### error

- 예상치 않은 문제나 오류가 발생했을 때 사용

### fault

- 앱의 불안정성을 야기하거나 크래시를 유발할 수 있는 잘못된 상태나 오류를 나타낼 때 사용
- error보다 심각한 상황에 적합

### Protocol

프로토콜은 약속이라고 생각한다.

- 타입 안정성 보장 : 특정 프로토콜을 준수하는 타입만을 요구하는 함수 등을 정의할 수 있다.
- 다형성 지원: 서로 다른 객체가 하나의 프로토콜을 준수하면서 다향성을 실현한다.
- 델리게이션 패턴 구현: 클래스나 구조체가 자신의 일부 책임을 다른 타입의 인스턴스에 위임할 수 있다.
- 확장성 제공: 프로토콜을 확장하여 기본 구현을 제공하고, 특정 조건을 만족하는 타입에 대해 추가적인 기능을 제공한다.

</div>
</details>

<details>
<summary>속성 변경 동작(Plane객체생성, UI 구현)</summary>

## 🎯주요 작업

- [x]  생성한 사각형 객체를 포함하는 Plane 구조체를 구현한다
- [x]  UI 컴포넌트 구현함

## 📚학습 키워드

**private**(**set**) **var**  : 외부에서는 읽기만 가능, 내부에서는 쓰기만 가능

## 💻고민과 해결

### Plane 구조체의 기능

- 새로운 사각형을 생성하고 Plane에 추가한다.
    - 배열과 추가하는 함수로 구현
- 사각형 전체 개수를 알려주는 연산 프로퍼티
- Subscrit로 index넘기면 해당 사각형 모델 return
- 터치 좌표를 넘기면 해당 위치를 포함하는 사각형 유무 확인

### 결과사진처럼 사각형,사진버튼이 여백없이 테두리선을 표현하고 싶었는데, 가운데 부분이 선이 중첩되서 두꺼워짐

<img width="684" alt="스크린샷 2024-03-20 오후 12 47 17" src="https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/6228dc98-39ca-40fb-9d5c-ddcdc1e2b5ae">

→ 방법 찾지 못해서 테두리 두께를 1로 하고, 가운데 여백을 줬음

### 포커게임 피드백을 받고, 저번처럼 지저분하게 뷰컨트롤러에 다 생성하지 않고, 하위뷰들을 만들어서 뷰 컨트롤러가 깔끔해지는 것에 목표를 두고 구현을 의도하였습니다.

## 🤔결과

<img width="679" alt="스크린샷 2024-03-20 오후 12 52 13" src="https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/e7d20bdb-837d-4a58-86e0-e58f2ad2cd8d">

![2일차 결과](https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/8ad55cc2-6ee8-435a-8f56-ee7b4e06bc83)

## 📚추가학습

### 팩토리 메소드와 생성자 init은 유사한데 왜 팩토리가 필요한가?

팩토리 메소드는 객체 생성 과정이 복잡하거나 추가적인 설정이 필요한 경우에 사용된다. 

지금 같은 경우 고유 ID 생성하여서 객체를 생성해야 하는 경우, 추가적인 초기화 작업을 팩토리 메소드 내부에서 처리할 수 있다.

그래서 

- 복잡성을 관리할 수 있다. - 복잡한 코드를 클라이언트 코드에서 숨길 수 있음
- 확장성과 유지보수성 향상 - 객체의 구체적인 타입을 쉽게 바꿀 수 있다.
- 테스트가 용이하다.

</div>
</details>

<details>
<summary>속성 변경 동작 (최종)</summary>

## 🎯주요 작업

- [x]  Plane 구조체를 테스트하는 유닛테스트를 추가한다.
- [x]  화면 하단에 사각형을 추가하는 버튼을 누르면 W150 x H120 크기 뷰를 랜덤한 위치에 랜덤 컬러로 추가하는 동작을 구현하기
- [x]  터치 이벤트 동작을 이해하고 원하는 곳에서 처리할 수 있다.
- [x]  뷰 속성 중에 배경색과 투명도를 바꿔서 다시 그릴 수 있다.

## 📚학습 키워드

### 탭 제스처 인식기

<img width="436" alt="스크린샷 2024-03-20 오후 10 32 47" src="https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/7cdd170d-841f-4785-bf06-1067f55cd99b">

### UIGestureRecognizer 하위클래스

하위 클래스를 통해 여러 제스처를 인식할 수 있다.

1. UITapGestureRecognizer : 싱글탭 또는 멀티탭 제스처
2. UIPinchGestureRecognizer : 핀치(Pinch) 제스처
3. UIRotationGestureRecognizer : 회전 제스처
4. UISwipeGestureRecognizer : 스와이프(swipe) 제스처
5. UIPanGestureRecognizer : 드래그(drag) 제스처
6. UIScreenEdgePanGestureRecognizer : 화면 가장자리 드래그 제스처
7. UILongPressGestureRecognizer : 롱 프레스(long-press) 제스처

### 예시 코드

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)

        setupView()
}

@objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        let selectedPoint = Point(x: location.x, y: location.y)
}
```

### iOS의 표준 제스처

1. Tap : 컨트롤을 활성화하거나 항목을 선택한다.
2. Drag : 아이템을 좌우 또는 화면을 드래그할 수 있다.
3. Flick : 빠르게 스크롤하거나 화면을 넘길 수 있다.
4. Swipe : 이전 화면으로 돌아가거나 테이블 뷰에서 숨겨진 삭제 버튼을 표시한다.
5. Double tap : 이미지 또는 콘텐츠를 확대하거나 다시 축소한다
6. Pinch : 이미지를 세밀하게 확대하거나 다시 축소한다.
7. Touch and hold : 커서 지정을 위한 확대보기 표시, 컬렉션 뷰의 경우 재배치할 수 있는 모드로 진입
8. Shake : 실행 취소 또는 다시 실행 얼럿을 띄운다.

## 💻고민과 해결

```swift
func contains(_ point: Point) -> Bool {
       let horizontalRange = point.x..<(point.x + size.width)
       let verticalRange = point.y..<(point.y + size.height)
        
     return horizontalRange.contains(point.x) && verticalRange.contains(point.y)
 }
```

사각형의 point가 포함되어 있는지를 판단하는 것인데, 계속 true값만 반환함

→ 매개변수의 point로 비교했음, self를 붙여서 해결한다.

<img width="436" alt="스크린샷 2024-03-20 오후 10 14 41" src="https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/e7388c0d-33c9-403e-8090-a56813d63657">


[ 회색배경은 버그를 잘 나타내기 위해 임의로 설정함 ]분명 사각형이 생성되는데 색이 보이질 않음

→ rgb값을 255로 나눠주지 않아서 발생한 버그

→ iOS에서 `UIColor`를 사용하여 색상을 지정할 때, 색상의 각 RGB 컴포넌트는 0.0에서 1.0 사이의 값을 사용한다. 

### 탭제스처로 location으로 좌표를 반환하여 Plane과 비교하는 고민

DrawingViewController에서 구현할려고 하였으나, main뷰컨트롤러에서 Setting뷰컨트롤러 너비를 뺀 너비안에서 생성하는 것이 더 적합하다고 판단하였다. DrawingViewController 삭제함.

### 터치가 될 때 사각형 테두리에 선을 표시해서 인지하도록 구현하기

- 터치를 통해 좌표를 얻는다.
- plane객체 안에 좌표를 넘겨서 사각형이 포함하는지 검사한다
- 검사된 모델을 뷰에서 찾는다. (사각형을 생성할 때 유니크 ID의 해쉬값으로 태그값에 넣었음) Tag값을 비교한다.
- 뷰에 모델이 존재하면 이전에 선택된 사각형의 테두리를 제거하고, 새로 선택된 테두리에 선을 표시한다.
- 빈영역을 선택하면 plane객체에 사각형이 없기때문에 이전에 선택된 사각형 테두리를 없애고 값도 nil로 넣는다.

### 버튼은 세팅뷰컨트롤러에 있고, 사각형 정보는 메인뷰컨트롤러에 있는데 뷰 컨트롤러간에 정보를 공유하는 방법

메인뷰컨트롤러에서 클로저를 통해 사각형 배경색과 투명도를 변경하는 이벤트를 전달한다

세팅뷰컨트롤러의 인스턴스에 접근하여 클로저를 설정하면 된다.

```swift
 private func setupOpacityAction() {
        settingsPanelViewController.onOpacityChangeRequested = { [weak self] newOpacity in
            guard let self = self,
                  let selectedRectangleView = self.selectedRectangleView else {
                self?.logger.error("선택된 사각형이 없습니다.")
                return
            }
            
            let rectangleModel = plane.rectangles.first { $0.uniqueID.hashValue == selectedRectangleView.tag }
            
            rectangleModel?.setOpacity(newOpacity)
            
            selectedRectangleView.alpha = CGFloat(newOpacity.rawValue) / 10.0
            logger.info("변경된 투명도는 \(Double(newOpacity.rawValue) / 10.0)")
        }
    }
```

클로저는 자신이 캡처(capture)한 모든 것에 대한 강한(strong) 참조를 기본으로 가진다. 그래서 `[weak self]` 구문을 사용하여 클로저가 self를 약하게 참조한다.

이로써, **`MainViewController`**와 **`SettingsPanelViewController`** 사이에 순환 참조가 발생하는 것을 방지한다.

## 🤔결과

![속성변경 최종결과](https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/8371ac28-4b5a-4c0a-b4f9-f1db7edd972e)

## 📚추가학습

Plane은 struct가 적당하였는가?

사각형을 관리하는 역할이기 때문에 클래스에 비해 변경하는 행위로부터 사각형 데이터를 보호하는 측면에서 더 적합하다고 생각한다.

내가 생각하는 클래스는 접근과 수정이 많이 요구될 때 사용하는 것이기 때문이다.

뷰 요소를 let으로 변수 선언부에 선언하는 것과 init에서 생성하는 것과 어떤 차이가 있을까?

let으로 변수 선언부에 선언하면 접근성과 재사용이 쉽고, 가독성이 좋다고 생각하고,

init으로 생성하면 인스턴스를 생성하는 순간 구성요소가 설정된 상태로 만들어지기 때문에 개발하는 사람은 추가적인 설정없이 바로 사용할 수 있는 장점이 있다고 생각한다.

</div>
</details>

<details>
<summary>관찰자 패턴</summary>

## 🎯주요 작업

- [x]  Model과 Controller의 직접적인 참조 관계 끊기
- [x]  NotificationCenter , Observer 프로젝트에 적용

## 📚학습 키워드

### Observer 패턴

모델은 자신이 상태가 변경되면 옵저버 등록된 객체에게 알려주고, 컨트롤러는 수신완료하여 필요한 반응을 할 수 있다.

### NotificationCenter

Notification이 오면 옵저버 패턴을 통해서 등록된 옵저버에게 Notification을 전달하기 위해 사용하는 클래스.

- 싱글톤 객체중 하나이며, 이벤트들의 발생 여부를 옵저버를 등록한 객체에게 Notification을 post하는 방식으로 사용
- post메서드를 통해 Notification을 전달하는데 이때, 이벤트에 대한 정보를 담은 객체이다.
- 각 알림은 Notification.Name이 있으며, 이를 통해 어떤 이벤트에 대한 알림인지 구분할 수 있다.
- 이름을 통해 알림 구독과 전달할 때 사용되는 Key값이다.

### Notification

- name : 전달하고자 하는 알림이름 (이를 통해 식별함)
- object : 발송자가 옵저버에게 보내려는 객체, 주로 발송자 객체를 전달하는데 쓰임
- userInfo : 알림과 관련된 값, 객체의 저장소이다 추가적인 데이터를 보내는데 쓰임

### 1. extension으로 [Notification.Name](http://Notification.Name) 추가하기

```swift
// Main뷰컨트롤러
extension Notification.Name {
    static let rectangleCreated = Notification.Name("rectangleCreated")
    static let rectangleColorChanged = Notification.Name("rectangleColorChanged")
    static let rectangleOpacityChanged = Notification.Name("rectangleOpacityChanged")
}
```

### 2. Notification Center에 옵저버 등록하기

```swift
// Main뷰컨트롤러
override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCreateRectangle(notification:)), name: .rectangleCreated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleColorChanged(notification:)), name: .rectangleColorChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOpacityChanged(notification:)), name: .rectangleOpacityChanged, object: nil)
    }
    
    
    @objc private func handleCreateRectangle(notification: Notification) {
        let rectangleModel = plane.createRectangleData()
        let rectangleView = plane.createRectangleView(rectangleModel)
        
        addRectangleViews(for: rectangleView, with: rectangleModel)
        view.bringSubviewToFront(drawableButtonStack)
        
        logger.info("사각형 생성 수신완료!!")
    }
    
    @objc private func handleColorChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let uniqueID = userInfo["uniqueID"] as? String,
              let randomColor = userInfo["randomColor"] as? RGBColor,
              let rectangleView = rectangleViews[uniqueID] else { return }
        
        updateViewBackgroundColor(for: rectangleView, using: randomColor)
        updateColorButtonTitle(with: randomColor)
        
        self.logger.info("배경색 변경 수신완료!")
    }
    
    @objc private func handleOpacityChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let uniqueID = userInfo["uniqueID"] as? String,
              let newOpacity = userInfo["opacity"] as? Opacity,
              let rectangleView = rectangleViews[uniqueID] else { return }
        
        updateViewOpacity(for: rectangleView, using: newOpacity)
        logger.info("투명도 변경 수신완료! 투명도: \(Double(newOpacity.rawValue) / 10.0)")
    }
```

### 3. NotificationCenter에 Post하기

```swift
 // Plane 객체
 mutating func updateRectangleColor(uniqueID: String) {
        let randomColor = getRandomColor()
        
        if let index = rectangles.firstIndex(where: { $0.uniqueID.value == uniqueID }) {
            rectangles[index].setBackgroundColor(randomColor)
            
            self.logger.info("배경색 변경 명령하달!")
            NotificationCenter.default.post(name: .rectangleColorChanged, object: nil, userInfo: ["uniqueID": uniqueID, "randomColor": randomColor])
        }
    }
```

## 💻고민과 해결

### 사각형을 생성하면 버튼위에 사각형이 생성되어서 버튼이 가려지는 현상

→ `bringSubviewToFront(_:)` 를 사용해서 사각형 생성될때마다 버튼스택뷰를 최상단으로 설정한다.

<img width="1095" alt="스크린샷 2024-03-22 오후 5 23 53" src="https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/f2780290-618b-450a-8905-7342f64d27d6">

### Tag값으로 subViews에 찾는 방법을 지양하고 다른 데이터 구조 모색

뷰 인스턴스 자체를 비교하기 위해 키값을 유니크ID value를 뷰 인스턴스로 딕셔너리를 만듬

## 🤔결과

![스텝3](https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/92538af0-8947-4c4c-9e5a-f451a03d0894)

## 📚추가학습

### 느슨하게 연결된 (loosed coupled) 구조가 왜 좋은가?

두 객체가 느슨하게 연결되어 있다는 것은 상호작용은 하지만, 서로에 대해 잘 모른다는 것을 의미한다.

그래서 서로 의존성이 줄어들어서 나중에 변경사항이 생기면 유연하게 유지보수를 할 수 있다.

즉, 객체지향 시스템을 유연하게 구축할 수 있다. → 객체 사이의 상호의존성을 최소화하기 때문에

</div>
</details>

<details>
<summary>사진 추가하기</summary>

## 🎯주요 작업

- [x]  사진 추가하기 동작
    - [x]  터치가 될때마다 사진이 있으면 선택, 빈영역을 선택할 경우 선택취소
    - [x]  선택되면 테두리에 선을 표시
    - [x]  배경색 지원 X, 투명도만 지원
- [x]  사진 불러오기
    - [x]  앨범에서 원하는 사진을 선택가능
    - [x]  불러온 사진은 바이너리 형태로 메모리에서만 데이터관리한다.
    - [x]  화면에 추가한 뷰 이외에 사진 데이터만 관리하는 모델타입을 선언한다.

## 📚학습 키워드

### URL

Uniform Resource Locator 자원을 가리키는 주소

모든 자원은 각각 고유한 URL을 가지고 있으며, 이를 통해 해당 자원에 접근할 수 있음.

### ImageView - 두번째 미션 1일차, 첫번째 미션 5일차

- **UIImageView**는 내부적으로 하나의 **UIImage**를 관리하는 뷰
- **UIImage**는 이미지 데이터를 나타내는 객체
- 이미지 뷰 속성들

### PhotoPicker  - 첫번째 미션 5일차

- 사용자의 미디어를 선택할 수 있는 뷰 컨트롤러
- **UIImagePickerController**
- **PHPickerViewController (iOS 14이상 권장) 최신**

1. 인스턴스 생성
2. 델리게이트 설정 
3. **present**

## 💻고민과 해결

### 1. 사진 추가할 때 입력-처리-출력을 구분하도록 노력하였습니다.

### 2. plane 모델과 photo모델의 공통된 동작이 보여서 추상화해야겠다고 생각했습니다. (ISP원칙 의도하도록 노력)

### Notification을 보내는 객체와 받는 객체 중에 어떤 객체와 더 관련이 높을까?

저는 보내는 객체가 더 관련성이 높다고 생각합니다.

물론 받는, 보내는 둘다 관련이 있지만 보내는 객체가 밀접한 관련이 있다고 생각합니다.

왜냐하면 결국 객체의 상태를 변화하는 것을 나타내기 때문입니다.

### **[에러] Missing package product <package name>**

[해결] File > Swift Packages > Reset Package Caches

## 🤔결과

![사진추가하기_결과](https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/9de053bb-9cf3-40d7-8dcd-4d4088285ce0)

## 📚추가학습

### addTarget와 removeTarget 두 메서드의 공통 파라미터

- target: 액션이 호출될 객체, nil일 경우 모든 이벤트도 받을 수 있다.
- action: 실행할 메서드를 가리키는 selector, nil일 경우 target에 대해 모든 액션을 의미한다.
- for: 이벤트 타입을 지정한다. 예시) .touchInside

### addTarget  removeTarget

특정 이벤트가 발생했을 때 실행하는 액션 메서드

### removeTarget

버튼에서 특정 액션을 제거하는데 사용하는 메서드

- target = nil, action = nil 인 경우: 지정된 이벤트에 대해 모든 타겟과 액션을 제거한다
- action = nil 인 경우: 지정된 타겟에 대해 모든 액션을 제거한다
- 둘다 nil이 아닌 경우: 모든 타겟에서 지정된 액션을 제거 한다.

</div>
</details>

<details>
<summary>터치와 드래그</summary>

## 🎯주요 작업

- [x]  제스처인식기 동작 방식 학습하고, Delegate로 제스처 처리하기
    - [x]  두 손가락을 터치를 기준으로 드래그 구현
    - [x]  Pan 제스처 인식기 추가해서 구현
    - [x]  사각형과 사진 모두 이동 가능하기
    - [x]  드래그 하는 동안 선택한 것을 캡쳐하고 투명도를 0.5 정도 임시뷰를 표시하기
    - [x]  손가락이 떨어지면 임시 뷰 사라짐, 선택한 뷰는 해당 위치 이동
    - [x]  다른 뷰와 겹치더라도 생성한 순서에 따라서 위 또는 아래 위치
    - [x]  화면에 보이는 뷰 좌표 뿐만 아니라 내부에서 처리하는 데이터 좌표도 변경

## 📚학습 키워드

### **UIGestureRecognizer - 세번째 미션 3일차**

### **snapshotView(afterScreenUpdates:)**

호출하는 당시의 뷰와 동일한 형태로 복사한다.

- afterScreenUpdates가 true인 경우 - 애니메이션과 같은 뷰 커밋이 끝난 경우 캡쳐
- afterScreenUpdates가 false인 경우 - 해당 시점에 바로 캡쳐

### UIPanGestureRecognizer.state

## 💻고민과 해결

### [버그] imageData로 뷰를 찾는데 이미지의 고유성을 보장하지 않는다. (같은 사진이 2장인 경우)

→ uniqueID으로 찾기

→ 리팩토링하다보니 굳이 UIView 하위가 UIImageView인데 따로 데이터 관리하는 것이 비효율적으로 생각함.

→ 하나의 딕셔너리에 모아서 관리하도록 하였음.

### [버그] 탭 제스처와 펜 제스처가 충돌하는 느낌이 듦.

→ 델리게이트 이용해서 탭 제스처가 되어서 테두리 선택이 되었을 때만 펜 제스처가 되도록 구현

### CGPoint, CGRect,frame,bound가 헷갈려서 노가다로 원하는 결과를 구현하였다.

→ 세번째 미션 2일차 좌표시스템 학습

## 🤔결과
![터치와드래그](https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/298639e6-4cb8-4f68-94f6-d4b6c7463214)

</div>
</details>

<details>
<summary>위치와 크기 속성 변경하기</summary>

## 🎯주요 작업

- [x]  화면 우측에 위치와 크기 정보를 추가
- [x]  사각형이나 사진을 선택하면 해당 객체의 속성을 표시
- [x]  위치와 크기 속성은 음수를 지원하지 않는다
- [x]  드래그로 위치를 이동하는 동안에도 변경되는 위치값을 표시
- [x]  선택한 사각형 객체의 배경색만 업데이트 표시한다.
- [x]  피드백
    - [x]  추상화된 타입을 활용하여 메서드 통합하여서 개선

## 💻고민과 해결

UIStepper 사용할려 했으나, 가로밖에 없어서 커스텀으로 버튼 마이너스, 플러스를 만들어서 Stepper를 대신하고자 노력함

**[질문] 점점 기능추가를 하면서 입력 - 처리 - 출력을 구분하기 위해 NotificationCenter를 통해 앱전체에 이벤트알림이 점점 많아지는 것이 자연스러운건지 궁금합니다.**

## 🤔결과
![위치와 크기 속성 변경하기](https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/17b6a079-537f-4192-88c4-4ef35a48b599)

</div>
</details>

<details>
<summary>텍스트 추가하기</summary>

## 🎯주요 작업

- [x]  settingsPanelViewController에서 직접 notification을 받도록 개선하기
- [x]  VisualComponent 자체를 key로 쓸 수 있는 방법도 생각하고 적용하기
- [x]  드래그할 때 투명도 안생기는 버그 고치기
- [x]  텍스트 추가하기
    - [x]  랜덤한 위치 지정해서 위치부터 공백기준 5단어 표시하기

## 📚학습 키워드

- 내부속성을 쓰는 것보다 객체 자체를 Key로 사용하는 것이 좋음. 유니크아이디는 같아도 속성이 다를 수 있기 때문에~

## 💻고민과 해결

## 💁‍♂️`selectedView.frame.origin.x`는 하위까지 다 풀어쓰고 `newWidth`는 할당했는 데 일관성있게 하셔도 좋을 것 같네요

### 🧙‍♂️나의 해결

```swift
// main뷰컨트롤러 handlePointUpdate메서드
let newWidth = newSize.width
let newheight = newSize.height
let selectedViewOriginX = selectedView.frame.origin.x
let selectedViewOriginY = selectedView.frame.origin.y
        
selectedView.frame = CGRect(x: selectedViewOriginX, y: selectedViewOriginY, width: newWidth, height: newheight)
```

## 💁‍♂️이 부분도 settingsPanelViewController에서 직접 notification을 받을 수 있지 않을까요?

```swift
// main뷰컨트롤러 handleColorChanged메서드 
self.logger.info("배경색 변경 수신완료!")
updateViewBackgroundColor(for: rectangleView, using: randomColor)       
self.settingsPanelViewController.backgroundStack.updateColorButtonTitle(with: randomColor)
```

### 🧙‍♂️나의 해결

```swift
// 변경될 때 rectangleColorChanged 수신받으면 업데이트 하도록 함 
// main과 setting 둘다 .rectangleColorChanged 수신받음
@objc private func handleColorChanged(notification: Notification) {
        guard let randomColor = notification.userInfo?["randomColor"] as? RGBColor else { return }
        
        self.logger.info("배경색 변경 수신완료(Setting)!")
        backgroundStack.updateColorButtonTitle(with: randomColor)
    }
```

## 💁‍♂️uniqueID를 key로 쓸수도 있지만, VisualComponent 자체를 key로 쓸 수 있는 방법도 생각해보세요.

```swift
private func findView(for component: VisualComponent) -> UIView? {
        return viewRegistry[component.uniqueID]
```

### 🧙‍♂️나의 해결

현재 Swift의 타입 시스템에서는 프로토콜 자체에 직접 **`Hashable`**을 채택할 수 없으며, 이는 구조적 한계로 인해 프로토콜 타입은 **`Hashable`**을 직접 채택할 수 없다.

"제네릭 프로토콜"을 콜렉션 타입으로 설정하면 컴파일 에러 발생

```swift
// 타입소거를 사용하여 키값으로 사용하고자 함.
struct AnyVisualComponent: Hashable {
    private(set) var component: VisualComponent
    
    init(_ component: VisualComponent) {
        self.component = component
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type(of: component)))
        hasher.combine(component.getUniqueID())
    }
    
    static func == (lhs: AnyVisualComponent, rhs: AnyVisualComponent) -> Bool {
        return lhs.component.getUniqueID() == rhs.component.getUniqueID()
    }
}
```

 **`VisualComponent`** 프로토콜을 준수하는 어떤 객체든지 **`viewRegistry`** 딕셔너리의 키로 사용할 수 있도록  **`AnyVisualComponent`**는 내부적으로 **`VisualComponent`** 프로토콜을 준수하는 객체를 감싸고, 이를 통해 **`Hashable`** 프로토콜 요구사항을 만족시키며, 딕셔너리의 키로 사용하여 해결하고자 함.

**[고민]**속성에 직접 접근하는 대신, 값을 가져오거나 설정하는 메서드를 프로토콜에 정의하는 방법을 생각했는데, 데이터관리를 할 때 사진모델과 사각형모델을 구분하지 않고 공통된 프로토콜을 채택하는 객체를 키값으로 데이터 관리하고 싶은데, 이때 get set구조를 하지 않고 객체지향 원칙을 지키면서 앱 돌아가는 구조에 대해 견문이 부족하여.. 방법이 떠오르지 않습니다.. 여러 방법을 모색했지만 결국 프로토콜에 get set구조가 선언되는 방법만 떠오릅니다.….💧😭😢😿🥲💦

## 💁‍♂️이 메소드는 settingsPanelViewController에 있어도 될 것 같은 내용이 많은 것 같습니다. 어떻게 생각해요?

```swift
// main뷰컨트롤러 viewTapped메서드 안에
        updateColorButtonTitle()
        updateStepperValueTitle()
    }
    
    private func updateColorButtonTitle() {
        if let selectedView = selectedView,
           let uniqueID = findKey(for: selectedView),
           let component = plane.findComponent(uniqueID: uniqueID) {
            if let color = component.backgroundColor {
                self.settingsPanelViewController.backgroundStack.updateColorButtonTitle(with: color)
            } else {
                self.settingsPanelViewController.backgroundStack.updateColorButtonTitle(with: nil)
            }
        } else {
            self.settingsPanelViewController.backgroundStack.updateColorButtonTitle(with: nil)
        }
    }
    
    private func updateStepperValueTitle() {
        if let selectedView = selectedView,
           let uniqueID = findKey(for: selectedView),
           let component = plane.findComponent(uniqueID: uniqueID) {
            let newX = Double(component.point.x)
            let newY = Double(component.point.y)
            let newWidth = Double(component.size.width)
            let newHeight = Double(component.size.height)
            
            self.settingsPanelViewController.pointStack.updateStepperValue(firstValue: newX, secondValue: newY)
            
            self.settingsPanelViewController.sizeStack.updateStepperValue(firstValue: newWidth, secondValue: newHeight)
        } else {
            self.settingsPanelViewController.pointStack.updateStepperValue(firstValue: 0, secondValue: 0)
            
            self.settingsPanelViewController.sizeStack.updateStepperValue(firstValue: 0, secondValue: 0)
        }
    }
```

### 🧙‍♂️나의 해결

```swift
// setting뷰컨트롤러 
func updateUIForSelectedComponent(_ component: VisualComponent?) {
        updateColorButtonTitle(with: component?.getColor())
        updateStepperValues(with: component)
    }

private func updateColorButtonTitle(with color: RGBColor?) {
        let color = color ?? nil
        backgroundStack.updateColorButtonTitle(with: color)
    }
    
private func updateStepperValues(with component: VisualComponent?) {
        let positionX = component?.getPoint().x ?? 0
        let positionY = component?.getPoint().y ?? 0
        let width = component?.getSize().width ?? 0
        let height = component?.getSize().height ?? 0
        
        pointStack.updateStepperValue(firstValue: Double(positionX), secondValue: Double(positionY))
        sizeStack.updateStepperValue(firstValue: Double(width), secondValue: Double(height))
    }
```

## 🤔결과
![텍스트추가하기](https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/22345222-e5f8-4914-9e58-936f2e9f3394)

</div>
</details>

<details>
<summary>오브젝트 목록 표시하기</summary>

## 🎯주요 작업

[ 피드백 개선 ]

- [x]  Plane과 팩토리 의존성 주입
- [x]  plane.updateRectangleColor()도 selectedModel을 그대로 넘기기
- [ ]  UITableView로 목록 형태 뷰를 표시하기
    - [x]  아래에서 위로 생성 순서를 표시하기
    - [x]  이미지 부분은 사각형, 이미지, 텍스트 일부를 작게 썸네일 표시
    - [x]  분류별로 생선 순서에 따라 숫자를 붙이기
        - [x]  목록에서 특정 요소를 길게 터치하면 메뉴 띄우기
        - [x]  맨 뒤로 보내기 - 목록 상에서 가장 아래로 내려가고, 가장 앞에 위치하기
        - [x]  맨 앞으로 보내기 - 목록 상에서 가장 위로 올라가고, 가장 뒤에 위치하기
        - [x]  뒤로 보내기나 앞으로 보내기하면 한 칸 내려가거나 올라가기
        - [ ]  목록을 터치하면 해당 오브젝트 선택한 것처럼 처리
        - [ ]  목록을 터치할 때마다 선택과 해제를 반복하도록 처리
        - [ ]  목록을 드래그해서 순서를 바꿀 수 있도록 처리

## 📚학습 키워드

### **UITableView**

### **UITableViewDataSource**

테이블뷰 화면을 보여주기 위해 필요한 함수

### **UITableViewDelegate**

테이블뷰 동작을 처리하기 위해 필요한 함수

## 💻고민과 해결

[고민] 테이블 셀을 가볍게 터치하면 선택된 것처럼 하고싶은데, long제스처 코드가 없을 때는 셀을 길게 누르고 떼면, 선택된 것처럼 돌아가는데, long제스처를 넣으면 둘이 겹쳐서 long제스처만 로직이 돌아간다.

## 🤔결과

![오브젝트 목록표시](https://github.com/codesquad-members-2024/swift-drawing/assets/104732020/3f73f2a9-9cd0-40f1-880c-e5ef4300dbc9)

## 📚추가학습

프로토콜 + 제네릭

버퍼타입을 생성하거나 호출할 때 제네릭이 결정된다. 파라미터로 넘겨줄 때 형태가 결정된다.

일반화 제네릭 타입은 타입이 다른데 동작이 똑같고 싶을 때

추상화 프로토콜은 형태가 똑같지만, 구현이 다를 수 있는 것

</div>
</details>
