# STUnitasHomeworkJskang
ST유니타스 과제 저장소

개발 언어 : Swift


통합 개발 환경 : XCode

-필수 구현 목표 수행 내용

사용자가 검색어를 입력하고 이미지 검색 결과를 화면에 표시하는 어플리케이션을 만들어야 합니다.

* 사용자가 검색어를 입력하면 이미지 검색 결과와 추가 정보들을 TableView 형식으로 표시하는 어플리케이션을 개발하였습니다.
* 다음 이미지 검색 API 를 사용하여 개발해야 합니다. (API 키는 본인이 직접 발급 받으셔야 합니다.
  
지정해주신 Kakao Rest Api를 이용하여 개발하였습니다.

* API 키는 제 카카오 개발자 계정으로 직접 발급받았습니다.
* 검색 결과는 JSON 형식으로 사용해야 합니다.
  
Kakao Rest Server로 request에 대한 response로 받은 결과 JSON 형식을 Dictionary에 Parsing 하여 App에서 사용할 수 있도록 하였습니다.
검색어 필드는 상단에 위치해야 합니다.

* 앱 실행 후 바로 검색 화면으로 진입하며, 검색어 TextField는 상단에 위치해 두었습니다.
    
검색 버튼은 없어야 하며, 1초 이상 검색어 입력이 없을 경우 검색 작업을 수행합니다.

* 검색 버튼을 사용하지 않았습니다.
* Swift의 Timer Class를 사용(내부적으로 Thread 사용) 하여 1초이상 검색어 입력이 없을 경우 검색 작업을 수행하도록 하였습니다.
    
검색 결과가 없거나 오류가 발생했을 경우 사용자에게 알려야 합니다.

* enum을 사용하여 ErrorType을 정의하였습니다.
* 현재 단말의 네트워크 연결이 안 된 경우, Kakao Rest Server로의 request가 실패한 경우, 검색 결과가 없는 경우에 대하여 오류 처리를 하였습니다.
* 오류 원인을 화면에 표시하여 사용자가 알 수 있도록 하였습니다.
    
검색 결과 이미지는 원본의 가로 세로 비율을 유지하여야 하며 이미지의 가로 사이즈는 화면 폭과 동일해야 합니다.

* 이미지 검색을 하면, TableView 형식으로 표시되는데, 테이블 항목을 선택 시 자세히 보기(크게 보기) 화면으로 넘어갑니다. 이때 이미지를 요청하신 대로, 원본의 가로 세로 비율을 유지하며, 이미지의 가로 사이즈는 화면의 폭을 채우도록 하였습니다.
* 화면 전환은 StoryBoard Segue를 사용하여 구현하였습니다.
    
페이징을 구현해야 합니다.

* TableView의 항목이 많을 경우 스크롤을 내릴 시에 한 페이지당 20개 항목을 로드하도록 페이징을 구현하였습니다.

Loading 중일 때 Loading 을 나타낼 수 있는 Indicator (Progress) 를 노출해야 합니다.

* ActivityIndicatorView를 사용하여 검색 중일 때 Loading을 화면에 표시하였습니다.

-제한 사항 수행 내용
사용 언어 : Swift

* Swift를 사용하여 개발하였습니다.
    
사용 필수 라이브러리 : Kingfisher, Alamofire

* Kakao Rest Server와의 연동 시, URLConnection Class가 아닌 Alamofire 라이브러리를 사용하여 통신 부분을 구현하였습니다.
* 검색 결과 이미지를 보여줄 때 Kingfisher 라이브러리를 사용하여 이미지가 쉽게 캐싱 될 수 있도록 하였습니다.
* Kingfisher와 Alamofire 라이브러리는 CocoaPods을 사용하여 프로젝트에 포함시켰습니다.
    
AutoLayout 사용.

* StoryBoard의 AutoLayoutConstraint를 사용하여 UI를 구성하였습니다.

-추가 구현 목표 수행 내용
RxSwift 사용

* RxSwift를 사용하진 않고, Swift를 사용하였습니다.
    
아키텍처 적용

* MVC(Model, View, Controller) 디자인 패턴을 적용하여 프로젝트 아키텍처를 구성하였습니다.
    
Unit Test 적용

* TableView 페이징 처리 시, 다음 페이지에 로드될 아이템 항목의 시작과 끝 Index를 계산하는 함수에 대하여 TestCase에 대한 UnitTest를 하였습니다.
    
UITableview/UICollectionView prefetching 사용

* UITableView prefetching을 사용하여 TableView의 현재 보이고 있는 항목 근처의 항목들까지 미리 로드하여 사용자 입장에서 부드러운 스크롤링이 가능하도록 하였습니다.

-기타 구현 사항

* String Localization을 사용하여 App이 핸드폰 언어 설정에 따른 다국어 지원(한국어, 영어)을 하도록 하였습니다.
* 추후 다른 RestApi 추가 사용을 고려하여 KakaoRestApiManager Class를 Singleton 패턴으로 구현하였고, 이 클래스를 통해 Api를 사용할 수 있도록 하였습니다.
