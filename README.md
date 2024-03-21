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
