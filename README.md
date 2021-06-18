# **team-08**

## 맴버

| CPR Position | Name |
| :-: | :--: |
| **iOS** | Min |  
| **FE** | DD | 
| **BE** | coco | 
| **BE** | marco | 


## WIKI
- [WIKI](https://github.com/ChoiGiSung/issue-tracker/wiki)
- [API 설계 (1주차)](https://github.com/ChoiGiSung/issue-tracker/wiki/%5BBE%5D-API-%EC%A0%95%EB%B3%B4)

# iOS

# issue-tracker
그룹프로젝트 #5

MVC 패턴이용

1. 로그인, OAuth 구현예정 (현재 미구현)

2. 이슈목록 
    - 이슈목록화면 TableView(TrailingtrailingSwipeActionsConfigurationForRowAt) 이용하여 구현
    - 현재 Display만 되고, 삭제 기능 구현 X
    - 검색바 SearchBarController 이용구현 (Search 기능 미구현)
    - 필터 (QueryString 형태로 Network 요청 보내 처리 예정)
    
3. 테스트함수 작성
    - Network Test 함수 작성

4. 실행결과화면
![ezgif com-gif-maker-2](https://user-images.githubusercontent.com/69951890/122515350-48a61a00-d048-11eb-9515-fbff18689155.gif)

# FE

## FE 진행 상황

### CRA (create-react-app) 직접 구현. (단, 몇 가지 예외처리가 아직 부족해서 프로젝트는 cra를 그대로 사용...)

> $ npx create-dd-app my-app 

관련 내용 블로깅 ([1편](https://velog.io/@jjunyjjuny/React-TS-boilerplate-%EC%A0%9C%EC%9E%91%EA%B8%B0-%ED%99%98%EA%B2%BD-%EA%B5%AC%EC%84%B1), [2편](https://velog.io/@jjunyjjuny/React-TS-boilerplate-%EC%A0%9C%EC%9E%91%EA%B8%B0-%EB%B0%B0%ED%8F%AC-%EB%B0%8F-npx))

<br/>

### 새로운(?) import/export 구조 적용 시도 중 

![image](https://user-images.githubusercontent.com/41738385/122521421-c0c40e00-d04f-11eb-90d4-1b8c911f6778.png)
![image](https://user-images.githubusercontent.com/41738385/122521454-cde0fd00-d04f-11eb-89dd-729592afdb47.png)
![image](https://user-images.githubusercontent.com/41738385/122521533-e4875400-d04f-11eb-9268-5c315a204a41.png)

import시 from으로 디렉토리에 접근하면 해당 디렉토리에 있는 index.ts를 찾는 로직을 응용, 그룹화 되어 있더라도 따로 모듈로 뺄 경우 모든 from에 파일명까지 지정해야하는 불편함 개선
이를 통해 import문을 깔끔하게 정리할 수 있는듯

### UI 코드 구현은 뒤늦게 시작해서 아직 보여줄만한 뷰가 없습니다. 




# BE

## DB 테이블
![image](https://user-images.githubusercontent.com/60220562/121634905-5ac00f80-cac0-11eb-86ca-942ec0438e40.png)
