# Generated migration for new features

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import uuid


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('applications', '0001_initial'),
        ('users', '0001_initial'),
    ]

    operations = [
        # Saved Search model
        migrations.CreateModel(
            name='SavedSearch',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=100)),
                ('description', models.TextField(blank=True)),
                ('filters', models.JSONField(default=dict)),
                ('is_default', models.BooleanField(default=False)),
                ('use_count', models.PositiveIntegerField(default=0)),
                ('last_used', models.DateTimeField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='saved_searches', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['-use_count', '-updated_at'],
                'unique_together': {('user', 'name')},
            },
        ),
        
        # Application Template model
        migrations.CreateModel(
            name='ApplicationTemplate',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=100)),
                ('description', models.TextField(blank=True)),
                ('category', models.CharField(blank=True, max_length=50)),
                ('job_type', models.CharField(blank=True, max_length=20)),
                ('work_location', models.CharField(blank=True, max_length=20)),
                ('cover_letter_template', models.TextField(blank=True)),
                ('notes_template', models.TextField(blank=True)),
                ('checklist', models.JSONField(default=list)),
                ('use_count', models.PositiveIntegerField(default=0)),
                ('is_favorite', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='application_templates', to=settings.AUTH_USER_MODEL)),
                ('default_resume', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='users.resume')),
                ('default_tags', models.ManyToManyField(blank=True, related_name='templates', to='applications.applicationtag')),
            ],
            options={
                'ordering': ['-use_count', '-updated_at'],
                'unique_together': {('user', 'name')},
            },
        ),
        
        # Cover Letter Template model
        migrations.CreateModel(
            name='CoverLetterTemplate',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=100)),
                ('description', models.TextField(blank=True)),
                ('content', models.TextField()),
                ('category', models.CharField(blank=True, max_length=50)),
                ('use_count', models.PositiveIntegerField(default=0)),
                ('is_default', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='cover_letter_templates', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['-use_count', '-updated_at'],
                'unique_together': {('user', 'name')},
            },
        ),
        
        # Resume Version model
        migrations.CreateModel(
            name='ResumeVersion',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=100)),
                ('description', models.TextField(blank=True)),
                ('file', models.FileField(upload_to='resumes/')),
                ('original_filename', models.CharField(max_length=255)),
                ('target_role', models.CharField(blank=True, max_length=100)),
                ('target_industry', models.CharField(blank=True, max_length=100)),
                ('version_number', models.CharField(default='1.0', max_length=20)),
                ('skills', models.JSONField(default=list)),
                ('use_count', models.PositiveIntegerField(default=0)),
                ('is_default', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='resume_versions', to=settings.AUTH_USER_MODEL)),
                ('parent_version', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='child_versions', to='applications.resumeversion')),
            ],
            options={
                'ordering': ['-is_default', '-use_count', '-created_at'],
            },
        ),
    ]
