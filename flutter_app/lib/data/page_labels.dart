import 'package:flutter/material.dart';

import '../core/l10n/localized.dart';

/// About page strings — from src/i18n/pages.js
class AboutLabels {
  static const title = L10nString(
    en: 'About OrthoExpress',
    es: 'Sobre OrthoExpress',
  );
  static const subtitle = L10nString(
    en: 'Your Trusted Orthopedic Care Partner',
    es: 'Su socio de confianza en atención ortopédica',
  );
  static const missionLabel = L10nString(en: 'Our Mission', es: 'Nuestra misión');
  static const missionTitle = L10nString(
    en: 'Dedicated to Your Recovery',
    es: 'Dedicados a su recuperación',
  );
  static const missionP1 = L10nString(
    en:
        'At OrthoExpress, we are dedicated to providing exceptional orthopedic care that is accessible, personalized, and focused on your recovery. Our mission is to help you regain your mobility, reduce pain, and return to the activities you love as quickly and safely as possible.',
    es:
        'En OrthoExpress, nos dedicamos a brindar atención ortopédica excepcional que sea accesible, personalizada y enfocada en su recuperación. Nuestra misión es ayudarle a recuperar su movilidad, reducir el dolor y volver a las actividades que ama de la manera más rápida y segura posible.',
  );
  static const missionP2 = L10nString(
    en:
        "We believe that quality healthcare should be available when you need it most. That's why we've built a practice centered around your convenience and comfort, ensuring that every interaction is focused on your healing and well-being.",
    es:
        'Creemos que la atención médica de calidad debe estar disponible cuando más la necesita. Por eso hemos construido una práctica centrada en su comodidad y bienestar, asegurando que cada interacción esté enfocada en su sanación.',
  );
  static const visionLabel = L10nString(en: 'Our Vision', es: 'Nuestra visión');
  static const visionTitle = L10nString(
    en: 'Healthcare Without Barriers',
    es: 'Atención médica sin barreras',
  );
  static const visionP1 = L10nString(
    en:
        'We envision a healthcare system where orthopedic care is readily available when you need it most. By offering walk-in appointments and same-day service, we eliminate the barriers that often delay treatment and recovery.',
    es:
        'Visualizamos un sistema de salud donde la atención ortopédica esté disponible cuando más la necesita. Al ofrecer citas sin cita y servicio el mismo día, eliminamos las barreras que a menudo retrasan el tratamiento y la recuperación.',
  );
  static const visionP2 = L10nString(
    en:
        "Our vision extends beyond just treating injuries—we're committed to transforming how orthopedic care is delivered, making it more accessible, efficient, and patient-centered for everyone in our community.",
    es:
        'Nuestra visión va más allá de tratar lesiones: estamos comprometidos a transformar cómo se brinda la atención ortopédica, haciéndola más accesible, eficiente y centrada en el paciente para todos en nuestra comunidad.',
  );
  static const whyLabel = L10nString(en: 'Why Choose Us', es: 'Por qué elegirnos');
  static const whyTitle = L10nString(
    en: 'Excellence in Every Aspect',
    es: 'Excelencia en cada aspecto',
  );
  static const feature1Title = L10nString(
    en: 'No Appointment Necessary',
    es: 'Sin cita necesaria',
  );
  static const feature1Text = L10nString(
    en: 'Walk in and receive expert care when you need it, without the wait.',
    es: 'Visite sin cita y reciba atención experta cuando la necesite, sin esperas.',
  );
  static const feature2Title = L10nString(en: 'Expert Physicians', es: 'Médicos expertos');
  static const feature2Text = L10nString(
    en: 'Board-certified orthopedic surgeons with years of experience.',
    es: 'Cirujanos ortopédicos certificados con años de experiencia.',
  );
  static const feature3Title = L10nString(en: 'Comprehensive Care', es: 'Atención integral');
  static const feature3Text = L10nString(
    en: 'From diagnosis to rehabilitation, we provide complete orthopedic services.',
    es: 'Desde el diagnóstico hasta la rehabilitación, ofrecemos servicios ortopédicos completos.',
  );
  static const feature4Title = L10nString(
    en: 'Personalized Treatment',
    es: 'Tratamiento personalizado',
  );
  static const feature4Text = L10nString(
    en: 'Every patient receives individualized care tailored to their unique needs.',
    es: 'Cada paciente recibe atención individualizada adaptada a sus necesidades únicas.',
  );
  static const storyLabel = L10nString(en: 'Our Story', es: 'Nuestra historia');
  static const storyTitle = L10nString(
    en: 'Built on Compassion and Excellence',
    es: 'Construidos sobre compasión y excelencia',
  );
  static const storyP1 = L10nString(
    en:
        "OrthoExpress was founded with a simple goal: to make quality orthopedic care accessible to everyone. We recognized that injuries don't wait for appointments, and neither should your treatment. Our walk-in clinic model ensures that you can receive expert orthopedic care on the same day, helping you start your recovery journey immediately.",
    es:
        'OrthoExpress fue fundado con un objetivo simple: hacer que la atención ortopédica de calidad sea accesible para todos. Reconocimos que las lesiones no esperan citas, y su tratamiento tampoco debería. Nuestro modelo de clínica sin cita garantiza que pueda recibir atención ortopédica experta el mismo día.',
  );
  static const storyP2 = L10nString(
    en:
        'Over the years, we have built a reputation for excellence, compassion, and innovation in orthopedic medicine. Our team of dedicated professionals works tirelessly to provide the highest standard of care while maintaining the personal touch that makes all the difference in your healing process.',
    es:
        'A lo largo de los años, hemos construido una reputación de excelencia, compasión e innovación en medicina ortopédica. Nuestro equipo de profesionales dedicados trabaja incansablemente para brindar el más alto estándar de atención.',
  );

  static List<({IconData icon, L10nString title, L10nString text})> features = [
    (icon: Icons.notifications_none, title: feature1Title, text: feature1Text),
    (icon: Icons.person_outline, title: feature2Title, text: feature2Text),
    (icon: Icons.check_circle_outline, title: feature3Title, text: feature3Text),
    (icon: Icons.groups_outlined, title: feature4Title, text: feature4Text),
  ];
}

/// Workers' compensation page — from src/i18n/pages.js
class WorkersCompLabels {
  static const intro1 = L10nString(
    en:
        "With our workers' compensation and injury care services, your employees get convenient access to high-quality care at a lower cost and in an appropriate setting.",
    es:
        'Con nuestros servicios de compensación laboral y atención de lesiones, sus empleados obtienen acceso conveniente a atención de alta calidad a menor costo y en el entorno adecuado.',
  );
  static const intro2 = L10nString(
    en:
        "Better care for employees. Better savings for companies. Employees love our responsive, personalized care. You'll love the reduced care costs we make possible.",
    es:
        'Mejor atención para empleados. Mejores ahorros para empresas. Los empleados aman nuestra atención personalizada y receptiva. A usted le encantarán los costos reducidos que hacemos posibles.',
  );
  static const section1 = L10nString(
    en: 'Experienced Orthopedic Clinicians',
    es: 'Clínicos ortopédicos experimentados',
  );
  static const section1Text = L10nString(
    en: 'Orthopedic clinicians are available on demand when you need them.',
    es: 'Clínicos ortopédicos disponibles a demanda cuando los necesite.',
  );
  static const section2 = L10nString(en: 'Comprehensive Treatment', es: 'Tratamiento integral');
  static const section2Text = L10nString(
    en:
        'On-site treatment strategies include advanced diagnostics, treatment and injection therapy for immediate or chronic workplace problems.',
    es:
        'Las estrategias de tratamiento en el sitio incluyen diagnósticos avanzados, tratamiento y terapia de inyección para problemas laborales inmediatos o crónicos.',
  );
  static const section3 = L10nString(en: 'Medication Management', es: 'Manejo de medicamentos');
  static const section3Text = L10nString(
    en:
        'Doctors at OrthoExpress clinics can prescribe medications to help manage pain, inflammation, and other symptoms associated with your work injury.',
    es:
        'Los médicos en las clínicas OrthoExpress pueden recetar medicamentos para ayudar a manejar el dolor, la inflamación y otros síntomas asociados con su lesión laboral.',
  );
  static const section4 = L10nString(en: 'Patient Education', es: 'Educación del paciente');
  static const section4Text = L10nString(
    en:
        'The clinic can provide you with educational resources on your specific work-related injury or illness, including tips on preventing future injuries and how to manage your condition effectively.',
    es:
        'La clínica puede proporcionarle recursos educativos sobre su lesión o enfermedad laboral específica, incluyendo consejos para prevenir futuras lesiones y cómo manejar su condición de manera efectiva.',
  );
  static const locationsTitle = L10nString(
    en: 'OrthoExpress Locations',
    es: 'Ubicaciones OrthoExpress',
  );
  static const bookLink = L10nString(
    en: "Book Workers' Comp Visit",
    es: 'Reservar visita de compensación laboral',
  );

  static List<({L10nString heading, L10nString text})> sections = [
    (heading: section1, text: section1Text),
    (heading: section2, text: section2Text),
    (heading: section3, text: section3Text),
    (heading: section4, text: section4Text),
  ];
}

/// Services list page — from src/i18n/pages.js `pages.services`
class ServicesLabels {
  static const eyebrow = L10nString(en: 'COMPREHENSIVE CARE', es: 'ATENCIÓN INTEGRAL');
  static const title = L10nString(en: 'Our Services', es: 'Nuestros servicios');
  static const intro = L10nString(
    en:
        'Walk-in orthopedic care for injuries, chronic conditions, and recovery — same-day appointments available at clinics near you.',
    es:
        'Atención ortopédica sin cita para lesiones, condiciones crónicas y recuperación — citas el mismo día disponibles en clínicas cerca de usted.',
  );
  static const coreHeading = L10nString(en: 'Core Services', es: 'Servicios principales');
  static const coreLead = L10nString(
    en:
        'Our primary walk-in orthopedic services — the same options available in the navigation menu.',
    es:
        'Nuestros servicios ortopédicos principales sin cita — las mismas opciones disponibles en el menú de navegación.',
  );
  static const specialtyHeading = L10nString(
    en: 'Specialty & Regional Care',
    es: 'Atención especializada y regional',
  );
  static const specialtyLead = L10nString(
    en:
        'Focused care for specific joints and body regions — each with its own dedicated treatment page.',
    es:
        'Atención enfocada en articulaciones y regiones específicas del cuerpo — cada una con su propia página de tratamiento.',
  );
  static const workersHeading = L10nString(
    en: "Workers' Compensation",
    es: 'Compensación laboral',
  );
  static const ctaPrompt = L10nString(
    en: 'Not sure which service you need?',
    es: '¿No está seguro de qué servicio necesita?',
  );
}

/// Locations list page — from src/i18n/pages.js `pages.locations`
class LocationsLabels {
  static const label = L10nString(en: 'CONTACT US', es: 'CONTÁCTENOS');
  static const title = L10nString(en: 'Locations', es: 'Ubicaciones');
  static const viewDetails = L10nString(en: 'View Details', es: 'Ver detalles');
  static const directions = L10nString(en: 'Directions', es: 'Indicaciones');
  static const headquarters = L10nString(en: 'Headquarters', es: 'Sede central');
}

/// Service detail page — from src/i18n/pages.js `pages.serviceDetail`
class ServiceDetailLabels {
  static const backLink = L10nString(en: '← All Services', es: '← Todos los servicios');
  static const about = L10nString(en: 'About This Service', es: 'Sobre este servicio');
  static const conditions = L10nString(
    en: 'Common Conditions We Treat',
    es: 'Condiciones comunes que tratamos',
  );
  static const treatments = L10nString(
    en: 'Treatment Options',
    es: 'Opciones de tratamiento',
  );
  static const whyChoose = L10nString(
    en: 'Why Choose Our Care',
    es: 'Por qué elegir nuestra atención',
  );
  static const bookAppointment = L10nString(en: 'Book Appointment', es: 'Reservar cita');
}

/// Location detail page — from src/i18n/pages.js `pages.locationDetail`
class LocationDetailLabels {
  static const locationFeatures = L10nString(
    en: 'Location Features',
    es: 'Características de la ubicación',
  );
  static const getDirections = L10nString(en: 'Get Directions', es: 'Cómo llegar');
  static const call = L10nString(en: 'Call', es: 'Llamar');
  static const book = L10nString(en: 'Book', es: 'Reservar');
  static const bookAppointment = L10nString(en: 'Book Appointment', es: 'Reservar cita');
}

/// Shared UI chrome — from src/i18n/translations.js `common`
class CommonLabels {
  static const contactUs = L10nString(en: 'Contact Us', es: 'Contáctenos');
  static const bookAppointment = L10nString(en: 'Book an Appointment', es: 'Reservar una cita');
}
