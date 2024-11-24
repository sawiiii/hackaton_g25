require "aws-sdk-bedrockruntime"
require "aws-sdk-core"

# Usage:
# service = GenerateLabelsService.new("Cargo para el que postula: Desarrollador de Software. Descripción del cargo: Desarrollar software de calidad, siguiendo las mejores prácticas y estándares de la industria. Requisitos: Experiencia en desarrollo de software, conocimientos en lenguajes de programación, capacidad para trabajar en equipo, proactividad y orientación a resultados.")
# labels = service.call

# puts labels


# content = "El proyecto consiste en el desarrollo de soluciones agropecuarias en la region sur del pais, cosechando salmones y otros peces de la zona"
# service = GenerateLabelsService.new(content)
# puts service.call
class GenerateLabelsService
  MODEL_ID = "anthropic.claude-3-haiku-20240307-v1:0".freeze

  CONTEXT = "
    Considerando las siguientes categorías, selecciona un máximo de 3 que más se ajustan a la descripción entregada. Necesito la respuesta sólo sea una lista de las categorías seleccionadas en formato JSON, you MUST return an array of the format [\"a\", \"b\", \"c\"]:
    [
      'Tecnología General',
      'Inteligencia Artificial',
      'Desarrollo de Software',
      'Desarrollo Web',
      'Aplicaciones Móviles',
      'Ciberseguridad',
      'Big Data y Ciencia de Datos',
      'Blockchain',
      'Internet de las Cosas (IoT)',
      'Cloud Computing y Redes',
      'Blockchain y Criptografía',
      'Automatización y DevOps',
      'Realidad Virtual y Aumentada',
      'IoT Industrial',
      'Ciudades Inteligentes',
      'Drones y Vehículos Autónomos',
      'Diseño Gráfico y Arte Digital',
      'UX/UI y Experiencia de Usuario',
      'Producción Audiovisual',
      'Fotografía',
      'Cine y Televisión',
      'Edición de Video',
      'Música y Sonido',
      'Gaming y Diseño de Juegos',
      'Streaming y Creación de Contenido',
      'Energías Renovables y Eficiencia Energética',
      'Cambio Climático y Sostenibilidad',
      'Reciclaje y Conservación de la Biodiversidad',
      'Gestión de Residuos y Agua',
      'Telemedicina y Salud Pública',
      'Nutrición y Rehabilitación',
      'Deporte y Fitness',
      'Gestión Empresarial y Startups',
      'Innovación Empresarial',
      'Finanzas y Banca',
      'Banca y Seguros',
      'Gestión de Proyectos',
      'Liderazgo y Coaching',
      'Educación General',
      'EdTech y Gamificación',
      'Ciencias Sociales y Humanidades',
      'Educación STEM y Ciencias',
      'Investigación Científica',
      'Divulgación Científica',
      'Astronomía y Física',
      'Química y Matemáticas',
      'Políticas Públicas y Derecho',
      'Seguridad Ciudadana y Defensa',
      'Gobierno Electrónico y Transparencia',
      'Ayuda Humanitaria y Proyectos Comunitarios',
      'Movilidad Urbana y Transporte Público',
      'Transporte y Logística General',
      'Cadena de Suministro',
      'Turismo y Hotelería',
      'Alimentación y Gastronomía',
      'Moda y Textil',
      'Agricultura, Ganadería y Pesca',
      'Arquitectura y Urbanismo',
      'Construcción y Obra Civil'
    ]
    "

  # @param [String] content the content to generate labels
  def initialize(content)
    @content = content
    access_key_id = Rails.application.credentials.aws.access_key_id
    secret_access_key = Rails.application.credentials.aws.secret_access_key
    @credentials = Aws::Credentials.new(access_key_id, secret_access_key)
    @client = Aws::BedrockRuntime::Client.new(region: "us-east-1", credentials: @credentials)
  end

  # Return a list of labels
  # @return [Array<String>]
  def call
    prompt = build_prompt
    request = build_request(prompt)
    response = build_response(request)
    response
  end

  private

  def build_prompt
    CONTEXT + @content
  end

  def build_request(prompt)
    request = {
      prompt: prompt,
      max_tokens_to_sample: 200
    }

    request = {
      "anthropic_version": "bedrock-2023-05-31",
      "max_tokens": 512,
      "temperature": 0.5,
      "messages": [
          {
              "role": "user",
              "content": [ { "type": "text", "text": prompt } ]
          }
      ]
    }

    request = JSON.dump(request)
  end

  def build_response(request)
    response = @client.invoke_model_with_response_stream(
      model_id: MODEL_ID, body: request
    )

    response = response.body

    response_message = ""

    for event in response
      bytes = event.bytes
      chunk = JSON.parse(bytes)
      if chunk["type"] == "content_block_delta"
        chunk_content = chunk["delta"].fetch("text", "")
        response_message += chunk_content
      end
    end

    JSON.parse(response_message)
  end
end
