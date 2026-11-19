import SwiftUI

@main
struct NeverlendApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView: View {
    @State private var key = ""
    @State private var isActivated = false
    @State private var selectedTab = 0
    @State private var fpsPreset = "120 FPS"
    @State private var sensitivity = 65.0
    @State private var showNotice = false

    private let red = Color(red: 1.0, green: 0.16, blue: 0.22)
    private let presets = ["60 FPS", "90 FPS", "120 FPS", "自動"]

    var body: some View {
        ZStack {
            Color(red: 0.035, green: 0.035, blue: 0.045).ignoresSafeArea()
            RadialGradient(colors: [red.opacity(0.16), .clear],
                           center: .topTrailing, startRadius: 5, endRadius: 420)
                .ignoresSafeArea()

            if !isActivated {
                activationView
            } else {
                mainView
            }
        }
        .preferredColorScheme(.dark)
        .alert("Demo activation", isPresented: $showNotice) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Это демонстрационная активация интерфейса. Настоящая проверка ключей требует защищённого сервера.")
        }
    }

    private var activationView: some View {
        VStack(spacing: 24) {
            Spacer()
            logo
            Text("PREMIUM GAME COMPANION")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .tracking(3)
                .foregroundStyle(.white.opacity(0.42))
            VStack(alignment: .leading, spacing: 10) {
                Text("АКТИВАЦИЯ")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(.white.opacity(0.65))
                TextField("Введи личный ключ", text: $key)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .padding(16)
                    .background(Color.white.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.09)))
                Button {
                    guard !key.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    isActivated = true
                    showNotice = true
                } label: {
                    Text("АКТИВИРОВАТЬ")
                        .font(.system(size: 13, weight: .black))
                        .tracking(1.5)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(LinearGradient(colors: [red, Color(red: 0.65, green: 0.03, blue: 0.12)], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(20)
            .background(Color.white.opacity(0.035))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.08)))
            Spacer()
            Text("NEVERLEND • iOS")
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundStyle(.white.opacity(0.28))
                .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
    }

    private var mainView: some View {
        VStack(spacing: 0) {
            header
            HStack(spacing: 8) {
                tabButton("ОБЗОР", icon: "square.grid.2x2", index: 0)
                tabButton("КАМЕРА", icon: "camera", index: 1)
                tabButton("УСТРОЙСТВО", icon: "iphone", index: 2)
            }
            .padding(6)
            .background(Color.white.opacity(0.045))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 18)
            .padding(.top, 18)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    if selectedTab == 0 { overview }
                    if selectedTab == 1 { cameraPanel }
                    if selectedTab == 2 { devicePanel }
                }
                .padding(18)
            }
            Spacer(minLength: 0)
            Text("STANDALONE COMPANION • NO GAME INJECTION")
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .tracking(1.2)
                .foregroundStyle(.white.opacity(0.25))
                .padding(.bottom, 12)
        }
    }

    private var header: some View {
        HStack {
            logo
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("STATUS")
                    .font(.system(size: 8, weight: .bold))
                    .tracking(1.5)
                    .foregroundStyle(.white.opacity(0.35))
                HStack(spacing: 6) {
                    Circle().fill(Color.green).frame(width: 6, height: 6)
                    Text("ACTIVE")
                        .font(.system(size: 10, weight: .heavy, design: .monospaced))
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var logo: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 11)
                    .fill(red.opacity(0.16))
                    .frame(width: 38, height: 38)
                Image(systemName: "bolt.fill")
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(red)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text("NEVERLEND")
                    .font(.system(size: 19, weight: .black, design: .rounded))
                    .tracking(1.4)
                Text("CONTROL CENTER")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .tracking(1.8)
                    .foregroundStyle(.white.opacity(0.35))
            }
        }
    }

    private var overview: some View {
        VStack(spacing: 14) {
            heroCard
            sectionTitle("БЫСТРЫЕ НАСТРОЙКИ", subtitle: "Параметры companion-приложения")
            settingCard(title: "Профиль производительности", detail: "Выбери целевой режим отображения", icon: "speedometer") {
                Picker("FPS", selection: $fpsPreset) {
                    ForEach(["60 FPS", "90 FPS", "120 FPS", "Авто"], id: \.self) { Text($0) }
                }
                .tint(red)
            }
            settingCard(title: "Чувствительность", detail: "Сохраняется как личный пресет", icon: "scope") {
                VStack(spacing: 6) {
                    Slider(value: $sensitivity, in: 1...100)
                        .tint(red)
                    HStack {
                        Text("1")
                        Spacer()
                        Text("\(Int(sensitivity)) / 100")
                            .foregroundStyle(.white.opacity(0.7))
                        Spacer()
                        Text("100")
                    }
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.35))
                }
            }
            infoCard
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("NEVERLEND / 01")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .tracking(1.5)
                    .foregroundStyle(red)
                Spacer()
                Image(systemName: "sparkles")
                    .foregroundStyle(red)
            }
            Text("ТВОЙ ИГРОВОЙ\nЦЕНТР УПРАВЛЕНИЯ")
                .font(.system(size: 25, weight: .black, design: .rounded))
                .tracking(-0.5)
            Text("Настройки, профили и инструменты устройства — в одном месте.")
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.48))
            HStack(spacing: 8) {
                badge("iOS 17+")
                badge("PERSONAL")
                badge("BETA")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(colors: [Color(red: 0.15, green: 0.045, blue: 0.065), Color.white.opacity(0.035)], startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle().fill(red.opacity(0.13)).frame(width: 160).blur(radius: 35).offset(x: 35, y: 55)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(red.opacity(0.22)))
    }

    private var cameraPanel: some View {
        VStack(spacing: 14) {
            sectionTitle("КАМЕРА", subtitle: "Профили и подсказки — без управления камерой игры")
            settingCard(title: "Режим обзора", detail: "Подсказка по настройке игрового FOV", icon: "viewfinder") {
                Text("Настраивается в меню самой игры")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(red)
            }
            settingCard(title: "Стабильность изображения", detail: "Рекомендации для комфортной игры", icon: "camera.aperture") {
                Text("Используй доступные настройки графики")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.65))
            }
            warningCard("Free Camera, WH и Aimbot не реализованы: приложение не внедряется в Oxide и не меняет игровые данные.")
        }
    }

    private var devicePanel: some View {
        VStack(spacing: 14) {
            sectionTitle("УСТРОЙСТВО", subtitle: "Локальные настройки приложения")
            settingCard(title: "Сессия ключа", detail: "Демонстрационный статус активации", icon: "key.fill") {
                Text("АКТИВНО")
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .foregroundStyle(.green)
            }
            settingCard(title: "Привязка устройства", detail: "Настоящая привязка требует серверной авторизации", icon: "iphone.gen3") {
                Text("НЕ НАСТРОЕНА")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(.orange)
            }
            Button("Выйти из демо-сессии") { isActivated = false; key = "" }
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(red)
                .padding(.top, 8)
        }
    }

    private var infoCard: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill").foregroundStyle(red)
            Text("Это отдельное companion-приложение. Оно не подключается к Oxide, не обходит блокировки и не гарантирует разблокировку FPS в самой игре.")
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.55))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.035))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func settingCard<Content: View>(title: String, detail: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(red)
                    .frame(width: 30, height: 30)
                    .background(red.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(.system(size: 13, weight: .bold))
                    Text(detail).font(.system(size: 10)).foregroundStyle(.white.opacity(0.38))
                }
                Spacer(minLength: 0)
            }
            content()
        }
        .padding(15)
        .background(Color.white.opacity(0.045))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.06)))
    }

    private func sectionTitle(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.system(size: 12, weight: .black)).tracking(1.5)
            Text(subtitle).font(.system(size: 10)).foregroundStyle(.white.opacity(0.35))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }

    private func badge(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 8, weight: .heavy, design: .monospaced))
            .tracking(0.7)
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(.white.opacity(0.07))
            .clipShape(Capsule())
    }

    private func warningCard(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "shield.lefthalf.filled").foregroundStyle(.orange)
            Text(text).font(.system(size: 10)).foregroundStyle(.white.opacity(0.58))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func tabButton(_ title: String, icon: String, index: Int) -> some View {
        Button { selectedTab = index } label: {
            VStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 13, weight: .bold))
                Text(title).font(.system(size: 8, weight: .black)).tracking(0.7)
            }
            .foregroundStyle(selectedTab == index ? .white : .white.opacity(0.35))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
            .background(selectedTab == index ? red.opacity(0.2) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}
